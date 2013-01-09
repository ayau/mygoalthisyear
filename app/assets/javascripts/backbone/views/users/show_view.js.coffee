Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.ShowView extends Backbone.View
    template: JST["backbone/templates/users/show"]

    initialize: ->
        @model.bind 'change', @UserLoaded

    # -> 
    UserLoaded: =>

        @current_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @model.id, route: 'current'})
        @current_view = new Bucketlist.Views.Goals.CurrentView(goals: @current_goals)

        $('.current').replaceWith(@current_view.render().el)

        @bucket_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @model.id, route: 'bucket'})
        @bucket_view = new Bucketlist.Views.Goals.BucketView(goals: @bucket_goals)
        
        $('.bucket').replaceWith(@bucket_view.render().el)

        @bucket_view.bucket_helper_view.bind('add_goal:success', @addGoal)
        @current_view.goal_form_view.bind('new_goal:success', @newGoal)
        
    render: ->
        # @$el.html(@template(@model.toJSON()))
        return this

    addGoal: (goal_id) =>
        @bucket_goals.remove(goal_id)
        # console.log goal_id

    newGoal: (goal, is_current) =>
        console.log 'here'
        console.log goal

        if is_current
            @current_goals.add(goal)
        else
            @bucket_goals.add(goal)
