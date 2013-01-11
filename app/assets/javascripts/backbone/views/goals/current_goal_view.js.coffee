Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.CurrentGoalView extends Backbone.View
    template: JST["backbone/templates/goals/current_goal"]

    tagName: 'li'
    className: 'goal'

    events: ->
        'click .giveup': @giveUp

    initialize: ->

        if @completed is 1
            className: 'goal completed'
        else
            className: 'goal'

    render: ->
        @$el.html(@template({goal: @model.toJSON()}))
        return this

    giveUp: (e) ->

        $.ajax({
            type: 'PUT',
            url: '/users/' + Bucketlist.me.id + '/remove_goal',
            dataType: 'json',
            data:
                goal_id: @model.id
            success: (results) =>
                @model.collection.trigger 'giveup', @model.id
        })
