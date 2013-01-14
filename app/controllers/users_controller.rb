class UsersController < ApplicationController

    include SvgHelper
    
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
        @points = @user.events.reduce(0) do |sum, event|
            sum + event.goal.points
        end

        # @current_goals = @month.goals.order('created_at DESC')
        @current_goals = @user.goals.where('is_current = 1').order('commitments.created_at DESC')

        month_time = Time.now.beginning_of_month()

        # Calculating points this month
        events_this_month = @user.events.where("created_at > ?", month_time)
        @points_this_month = events_this_month.reduce(0) do |sum, event|
            sum + event.goal.points
        end

        # hash of goal_id vs number of events in that month
        @events_count = @user.events.where("created_at > ?", month_time).group(:goal_id).count

        # appending subgoals to goals
        subgoals = @user.subgoals.where('is_current = 1')
        @subgoals = {}
        subgoals.each do |sg|
            @subgoals[sg.parent_id] ||= []
            @subgoals[sg.parent_id] << sg
        end

        # new goal
        @goal = Goal.new

        @bg_color = "%06x" % (rand * 0xffffff)
        @fg_color = generate_color(@bg_color)

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

        goal_id = params[:goal_id]
        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, goal_id)

        # update created at for ordering
        commitment.update_attributes({:is_current => 1, :created_at => Time.now})
        
        respond_to do |format|
            format.html { redirect_to current_user }
            format.json { render json: {:success => 'yay'} }
        end
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
            results = User.find(:all, :select => 'id, name, avatar', :conditions => ['name LIKE ? AND id != ?', "%#{search}%", current_user.id])
        else
            results = []
        end

        respond_to do |format|
            format.json { render json: results }
        end

    end

    def achievements
        @user = User.find(params[:id])
        @completed = @user.goals.where('completed = ?', 1)
    end


    # API
#     def as_json(options={})
#       super(:only => [:first_name,:last_name,:city,:state],
#         :include => {
#           :employers => {:only => [:title]},
#           :roles => {:only => [:name]}
#         }
#      )
# end
    def me
        raise PermissionViolation unless current_user
        render json: current_user.as_json(:only => [:id, :name, :avatar, :auto_add])
    end

    def goals
        user = User.find(params[:id])
        raise PermissionViolation unless user.viewable_by?(current_user)

        current_goals = user.goals.where('is_current = 1').order('commitments.created_at DESC')
        # subgoals = user.subgoals.where('is_current = 1')

        # inefficient if user has a lot of current goals + current subgoals
        # map reduce?
        # current = current_goals.as_json
        # subgoals.each do |goal|
        #     current.each do |goal|
        # end

        completed = user.goals.where('completed = ?', 1)
        bucket = user.goals.where('is_current = ?', 0)

        render json: {
            :current => current_goals,
            :completed => completed,
            :bucket => bucket
        }

    end

    def current_goals
        user = User.find(params[:id])
        raise PermissionViolation unless user.viewable_by?(current_user)

        month_time = Time.now.beginning_of_month()

# Refactor to use a join instead
        # hash of goal_id vs number of events in that month
        events_count = user.events.where("created_at > ?", month_time).group(:goal_id).count
        
        current_goals = user.goals.where('is_current = 1').order('commitments.created_at ASC')

        subgoals = user.subgoals.group_by {|d| d[:parent_id]}

        current_goals = current_goals.as_json()

        current_goals.each do |goal|
            goal['events_in_month'] = events_count[goal['id']] || 0
            goal['subgoals'] = subgoals[goal['id']] || []
        end

        render json: current_goals        
    end


    def bucket_goals
        user = User.find(params[:id])
        raise PermissionViolation unless user.viewable_by?(current_user)
        
        # This needs to be ordered by date added in (even from giveup)
        bucket = user.goals.where('is_current = ?', 0)

        render json: bucket        
    end

end
