class EventsController < ApplicationController
    # GET /events
    # GET /events.json
    # def index        
    #     @events = Event.all

    #     respond_to do |format|
    #         format.html # index.html.erb
    #         format.json { render json: @events }
    #     end
    # end

    # GET /events/1
    # GET /events/1.json
    # def show
    #     @event = Event.find(params[:id])

    #     respond_to do |format|
    #         format.html # show.html.erb
    #         format.json { render json: @event }
    #     end
    # end

    # GET /events/new
    # GET /events/new.json
    # def new
    #     @event = Event.new

    #     respond_to do |format|
    #         format.html # new.html.erb
    #         format.json { render json: @event }
    #     end
    # end

    # GET /events/1/edit
    def edit
        @event = Event.find(params[:id])
        raise PermissionViolation unless @event.updatable_by?(current_user)
    end

    # POST /events
    # POST /events.json
    def create
        event = {
            :goal_id => params[:goal_id],
            :user_id => current_user.id
        }

        @event = Event.new(event)

        raise PermissionViolation unless @event.creatable_by?(current_user)

        respond_to do |format|
            if @event.save
                format.html { redirect_to current_user, notice: 'Event was successfully created.' }
                format.json { render json: @event, status: :created, location: @event }
            else
                format.html { render action: "new" }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /events/1
    # PUT /events/1.json
    def update
        @event = Event.find(params[:id])

        raise PermissionViolation unless @event.updatable_by?(current_user)

        respond_to do |format|
            if @event.update_attributes(params[:event])
                format.html { redirect_to @event.goal, notice: 'Event was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /events/1
    # DELETE /events/1.json
    def destroy
        @event = Event.find(params[:id])
        @event.destroy

        raise PermissionViolation unless @event.destroyable_by?(current_user)

        respond_to do |format|
            format.html { redirect_to :back }
            format.json { head :no_content }
        end
    end

    # POST /events/add_details
    # add_details_events
    def add_details
        event = Event.find_all_by_user_id_and_goal_id(current_user.id, params[:event][:goal_id]).last

        raise PermissionViolation unless event.updatable_by?(current_user)

        event.update_attributes(params[:event])

        # since is now able to submit from both pages
        redirect_to :back

        # redirect_to event.user
    end

end
