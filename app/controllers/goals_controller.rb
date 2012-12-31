class GoalsController < ApplicationController

    # GET /goals
    # GET /goals.json
    def index
        raise PermissionViolation unless Goal.listable_by?(current_user)

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

        raise PermissionViolation unless @goal.viewable_by?(current_user)

        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, @goal.id)

        @user = current_user
        @goal['completed'] = commitment.completed
        @goal['completed_at'] = commitment.completed_at


        @subgoal = Goal.new

        @subgoals = @goal.subgoals

        @events = Event.where(:goal_id => @subgoals.group(:id).append(@goal.id))

        @events_count = @events.group(:goal_id).count 

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @goal }
        end
    end

    # GET /goals/new
    # GET /goals/new.json
    # def new
    #     @goal = Goal.new(:parent_id => params[:parent_id])

    #     respond_to do |format|
    #         format.html # new.html.erb
    #         format.json { render json: @goal }
    #     end
    # end

    # GET /goals/1/edit
    def edit
        @goal = Goal.find(params[:id])
        raise PermissionViolation unless @goal.updatable_by?(current_user)
    end

    # POST /goals
    # POST /goals.json
    def create
        # validate that current_user exists

        goal = params[:goal]
        goal['owner_id'] = current_user.id
    
        auto_add = params[:goal][:user]

        goal.delete('user')
        @goal = Goal.new(goal)
        raise PermissionViolation unless @goal.creatable_by?(current_user)

        # Saving auto_add preference
        current_user.update_attributes(auto_add)

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
        raise PermissionViolation unless @goal.updatable_by?(current_user)

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
        raise PermissionViolation unless @goal.destroyable_by?(current_user)

        @goal.destroy

        respond_to do |format|
            format.html { redirect_to user_path(current_user) }
            format.json { head :no_content }
        end
    end

    # Mark a goal as complete and adds goal to month (if not already in month)
    # If the goal contains subgoals, subgoals are marked as completed (and added to month)
    def complete
        goal_id = params[:id]
        
        @goal = Goal.find(goal_id)
        raise PermissionViolation unless @goal.updatable_by?(current_user)


        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, goal_id)
        commitment.update_attributes(:completed => true, :completed_at => Time.now)

        # incomplete_descendants = @goal.descendants.where(:completed => false)


        # for d in incomplete_descendants
        #     # logger.debug "Incomplete descendants completed #{d.name}"
        #     d.update_attributes(:completed => true, :completed_at => Time.now)
        #     unless month.goals.include?(d)
        #         month.goals << d
        #     end
        # end

        redirect_to user_path(current_user)
    end

    def make_incomplete
        goal_id = params[:id]

        @goal = Goal.find(goal_id)
        raise PermissionViolation unless @goal.updatable_by?(current_user)
        
        commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, goal_id)
        commitment.update_attributes(:completed => false)

        redirect_to user_path(current_user)
    end

    def subgoals
        # validate that parent and current_user exist
        goal = params[:goal]

        parent = Goal.find(goal[:parent_id])
        raise PermissionViolation unless parent.updatable_by?(current_user) 

        goal['owner_id'] = current_user.id
        
        parent = Goal.find(goal[:parent_id])

        @goal = Goal.new(goal)

        respond_to do |format|
            if @goal.save
                format.html { redirect_to parent, notice: 'Goal was successfully created.' }
                format.json { render json: @goal, status: :created, location: @goal }
            else
                format.html { render action: "new" }
                format.json { render json: @goal.errors, status: :unprocessable_entity }
            end
        end
    end

    def choose_subgoal
        @goal = Goal.find(params[:id])
        raise PermissionViolation unless @goal.updatable_by?(current_user)
        

        @subgoals = current_user.subgoals.find_all_by_parent_id(@goal.id)
    end

    def set_subgoal
        goal = Goal.find(params[:id])
        raise PermissionViolation unless goal.updatable_by?(current_user)
        

        subgoals = current_user.subgoals.find_all_by_parent_id(goal.id)

        selected_subgoals = params[:subgoals] || []

        for subgoal in subgoals
            id = subgoal.id
            is_current = selected_subgoals.include?(id.to_s) ? 1 : 0
            commitment = Commitment.find_by_user_id_and_goal_id(current_user.id, id)
            commitment.update_attributes(:is_current => is_current)
            logger.info commitment.is_current
        end
        
        redirect_to current_user
    end

end
