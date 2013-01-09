Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.ShowView extends Backbone.View
    template: JST["backbone/templates/users/show"]

    initialize: ->
        @model.bind 'change', @UserLoaded

    # -> 
    UserLoaded: =>

        # @current_goals = new Bucketlist.Collections.GoalsCollection(@id, 'current')
        @bucket_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @model.id, route: 'bucket'})
        @bucket_view = new Bucketlist.Views.Goals.BucketView(goals: @bucket_goals)
        
        $('.bucket').replaceWith(@bucket_view.render().el)

        @bucket_view.bucket_helper_view.bind('add_goal:success', @addGoal)
        
    render: ->
        # @$el.html(@template(@model.toJSON()))
        return this

    addGoal: (goal_id) =>
        @bucket_goals.remove(goal_id)
        # console.log goal_id
