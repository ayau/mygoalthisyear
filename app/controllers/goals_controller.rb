class GoalsController < ApplicationController
    # GET /goals
    # GET /goals.json
    def index
        @goals = Goal.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @goals }
        end
    end

    # GET /goals/1
    # GET /goals/1.json
    def show
        @goal = Goal.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @goal }
        end
    end

    # GET /goals/new
    # GET /goals/new.json
    def new
        @goal = Goal.new(:parent_id => params[:parent_id])

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @goal }
        end
    end

    # GET /goals/1/edit
    def edit
        @goal = Goal.find(params[:id])
    end

    # POST /goals
    # POST /goals.json
    def create
        # validate that current_user exists

        goal = params[:goal]
        goal['user_id'] = current_user.id
        @goal = Goal.new(goal)

        respond_to do |format|
            if @goal.save
                format.html { redirect_to user_path(current_user), notice: 'Goal was successfully created.' }
                format.json { render json: @goal, status: :created, location: @goal }
            else
                format.html { render action: "new" }
                format.json { render json: @goal.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /goals/1
    # PUT /goals/1.json
    def update
        @goal = Goal.find(params[:id])

        respond_to do |format|
            if @goal.update_attributes(params[:goal])
                format.html { redirect_to @goal, notice: 'Goal was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @goal.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /goals/1
    # DELETE /goals/1.json
    def destroy
        @goal = Goal.find(params[:id])
        @goal.destroy

        respond_to do |format|
            format.html { redirect_to user_path(current_user) }
            format.json { head :no_content }
        end
    end

    # Mark a goal as complete and adds goal to month (if not already in month)
    # If the goal contains subgoals, subgoals are marked as completed (and added to month)
    def complete
        @goal = Goal.find(params[:id])
        @goal.update_attributes(:completed => true, :completed_at => Time.now)

        # Add goal to current month if not already in there
        month = current_user.months.find(:first, :order=>'created_at desc')

        unless month.goals.include?(@goal)
            month.goals << @goal
        end

        incomplete_descendants = @goal.descendants.where(:completed => false)

        for d in incomplete_descendants
            # logger.debug "Incomplete descendants completed #{d.name}"
            d.update_attributes(:completed => true, :completed_at => Time.now)
            unless month.goals.include?(d)
                month.goals << d
            end
        end

        redirect_to user_path(current_user)
    end

    def make_incomplete
        @goal = Goal.find(params[:id])
        @goal.update_attributes(:completed => false)

        redirect_to user_path(current_user)
    end
end
