class UsersController < ApplicationController
    
    # GET /users
    # GET /users.json
    def index
        raise PermissionViolation unless User.listable_by?(current_user)

        @users = User.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @users }
        end
    end

    # GET /users/1
    # GET /users/1.json
    def show

        uid = params[:id] || current_user
        @user = User.find(uid)

        raise PermissionViolation unless @user.viewable_by?(current_user)


        @completed = @user.goals.where('completed = ?', 1)
        @bucket = @user.goals.where('is_current = ?', 0)

        # Don't over-count evented + completed goals
        points = @completed.reduce(0) do |sum, goal|
            sum += goal.events.count > 0 ? goal.points : 0
        end

        @points = @user.events.reduce(points) do |sum, event|
            sum + event.goal.points
        end

        # create a new month if current time > last month
        # @month = @user.get_month

        # @current_goals = @month.goals.order('created_at DESC')
        @current_goals = @user.goals.where('is_current = ?', 1).order('commitments.created_at DESC')

        # Calculating points this month
        # points_this_month = @month.goals.where(:completed => true).reduce(0) do |sum, goal|
        #     sum += goal.events.count > 0 ? goal.points : 0
        # end

        # hash of goal_id vs number of events in that month
        month_time = Time.now.beginning_of_month()

        # events_this_month = @user.events.where("created_at > ?", month_time)
        # @points_this_month = events_this_month.reduce(points_this_month) do |sum, event|
        #     sum + event.goal.points
        # end
        @points_this_month = 0

        @events_count = @user.events.where("created_at > ?", month_time).group(:goal_id).count

        # appending subgoals to goals
        subgoals = @user.subgoals.where('is_current == 1')
        @subgoals = {}
        subgoals.each do |sg|
            @subgoals[sg.parent_id] ||= []
            @subgoals[sg.parent_id] << sg
        end

        # new goal
        @goal = Goal.new

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @user }
        end
    end

    # GET /users/new
    # GET /users/new.json
    # def new
    #     @user = User.new

    #     respond_to do |format|
    #         format.html # new.html.erb
    #         format.json { render json: @user }
    #     end
    # end

    # GET /users/1/edit
    def edit
        @user = User.find(params[:id])
        raise PermissionViolation unless @user.updatable_by?(current_user)
    end

    # POST /users
    # POST /users.json
    def create
        @user = User.new(params[:user])
        raise PermissionViolation unless @user.creatable_by?(current_user)

        respond_to do |format|
            if @user.save
                format.html { redirect_to @user, notice: 'User was successfully created.' }
                format.json { render json: @user, status: :created, location: @user }
            else
                format.html { render action: "new" }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /users/1
    # PUT /users/1.json
    def update
        @user = User.find(params[:id])
        raise PermissionViolation unless @user.updatable_by?(current_user)

        respond_to do |format|
            if @user.update_attributes(params[:user])
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        @user = User.find(params[:id])
        raise PermissionViolation unless @user.destroyable_by?(current_user)

        @user.destroy

        respond_to do |format|
            format.html { redirect_to users_url }
            format.json { head :no_content }
        end
    end

    # GET /users/:id/timeline
    def timeline
        @user = User.find(params[:id])
    end


    def add_goal
        @user = User.find(params[:id])
        raise PermissionViolation unless @user.updatable_by?(current_user)

        goal_id = params[:user][:goal_id]
        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, goal_id)

        # update created at for ordering
        commitment.update_attributes({:is_current => 1, :created_at => Time.now})
        
        redirect_to current_user
    end

    def remove_goal
        @user = User.find(params[:id])
        raise PermissionViolation unless @user.updatable_by?(current_user)

        goal_id = params[:goal_id]
        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, goal_id)

        # need to check if commitment is valid
        commitment.update_attributes(:is_current => 0)
        
        redirect_to current_user
    end

    def search
        search = params[:search]
        
        if search
            results = User.find(:all, :select => 'id, name, avatar', :conditions => ['name LIKE ?', "%#{search}%"])
        else
            results = []
        end

        respond_to do |format|
            format.json { render json: results }
        end

    end

end
