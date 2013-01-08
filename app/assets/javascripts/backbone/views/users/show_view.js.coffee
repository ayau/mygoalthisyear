Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.ShowView extends Backbone.View
    template: JST["backbone/templates/users/show"]

    initialize: ->
        @model.bind 'change', @UserLoaded

    UserLoaded: ->
        # @current_goals = new Bucketlist.Collections.GoalsCollection(@id, 'current')
        @bucket_goals = new Bucketlist.Collections.GoalsCollection({}, {user_id: @id, route: 'bucket'})
        # @bucket_view = new Bucketlist.Views.

    render: ->
        # @$el.html(@template(@model.toJSON()))
        return this
