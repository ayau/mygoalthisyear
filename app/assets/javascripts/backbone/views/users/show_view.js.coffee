Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.ShowView extends Backbone.View
    template: JST["backbone/templates/users/show"]

    initialize: ->
        @model.bind 'change', @UserLoaded

    # -> 
    UserLoaded: =>

        @user_view = new Bucketlist.Views.Users.UserView(model: Bucketlist.me)
        $('.user-header').replaceWith(@user_view.render().el)

        @current_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @model.id, route: 'current'})
        @current_view = new Bucketlist.Views.Goals.CurrentView(goals: @current_goals)

        $('.current').replaceWith(@current_view.render().el)

        @bucket_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @model.id, route: 'bucket'})
        @bucket_view = new Bucketlist.Views.Goals.BucketView(goals: @bucket_goals)
        
        $('.bucket').replaceWith(@bucket_view.render().el)

        @bucket_view.bucket_helper_view.bind('add_goal:success', @addGoal)
        @current_view.goal_form_view.bind('new_goal:success', @newGoal)

        @current_goals.bind('giveup', @giveUp)

        @initDocumentClick()
        
    render: ->
        # @$el.html(@template(@model.toJSON()))
        return this

    addGoal: (goal_id) =>
        goal = @bucket_goals.get(goal_id)
        @bucket_goals.remove(goal_id)
        @current_goals.add(goal)

    newGoal: (goal, is_current) =>
        if is_current
            @current_goals.add(goal)
        else
            @bucket_goals.add(goal)

    giveUp: (goal_id) =>
        goal = @current_goals.get(goal_id)        
        @current_goals.remove(goal_id)
        @bucket_goals.add(goal)

    initDocumentClick: ->

        $(document).live 'click', (e) =>
            if @current_view.goal_form_view.badgeOpened
                $('.badge-select').fadeOut()
                @current_view.goal_form_view.badgeOpened = false
                return

            if @current_view.goal_form_view.colorOpened
                $('.color-picker').fadeOut()
                @current_view.goal_form_view.colorOpened = false
                return

            # Automatically hides more options of add a goal
        # Don't hide if stuff's been filled in?
            if @current_view.goal_form_view.optionsExtended
                $('.more-options').click()

        # # Don't hide if form filled in
            if @current_view.event_form_view.eventExtended && !@current_view.event_form_view.isFilledIn()
                @current_view.event_form_view.closeForm()




