class UsersController < ApplicationController
    # GET /users
    # GET /users.json
    def index
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
        @completed = @user.goals.where(:completed => true)
        @bucket = @user.goals.where(:completed => false)

        points = @completed.reduce(0) do |sum, goal|
            sum + goal.points
        end

        @points = @user.events.reduce(points) do |sum, event|
            sum + event.goal.points
        end

        # create a new month if current time > last month
        @month = getMonth(@user)

        @current_goals = @month.goals.order('completed ASC, created_at DESC')

        # Calculating points this month
        points_this_month = @month.goals.where(:completed => true).reduce(0) do |sum, goal|
            sum + goal.points
        end

        # hash of goal_id vs number of events in that month
        month_time = @month.created_at.beginning_of_month()

        events_this_month = @user.events.where("created_at > ?", month_time)
        @points_this_month = events_this_month.reduce(points_this_month) do |sum, event|
            sum + event.goal.points
        end


        @events = @user.events.where("created_at > ?", month_time).group(:goal_id).count 

        # new goal
        @goal = Goal.new

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @user }
        end
    end

    # GET /users/new
    # GET /users/new.json
    def new
        @user = User.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @user }
        end
    end

    # GET /users/1/edit
    def edit
        @user = User.find(params[:id])
    end

    # POST /users
    # POST /users.json
    def create
        @user = User.new(params[:user])

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




    private

    # Retrieves current month object. Creates one if doesn't exist
    def getMonth(user)
        months = user.months.order("created_at desc").limit(1)
        month = months[0]
        if !month || month.created_at.beginning_of_month() < Time.now.utc.beginning_of_month()
            param = {
                'user_id' => current_user.id
            }
            month = Month.new(param)
            month.save    
        end

        month
    end

end
