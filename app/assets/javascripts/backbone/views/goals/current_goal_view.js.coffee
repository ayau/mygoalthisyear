Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.CurrentGoalView extends Backbone.View
    template: JST["backbone/templates/goals/current_goal"]

    tagName: 'li'
    className: 'goal'

    events: ->
        'click .giveup': @giveUp
        'click .new_event': @newEvent
        'click .mark-complete': @markComplete
        'click .mark-incomplete': @markIncomplete

    render: ->
        if @model.get('completed') is 1
            @$el.addClass 'completed'
        else
            @$el.removeClass 'completed'

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

    newEvent: ->
        @model.collection.trigger 'newEvent', @

    markComplete: ->
        @model.set('completed', 1)

        $.ajax({
            type: 'PUT',
            url: '/goals/' + @model.get('id') + '/complete',
            dataType: 'json'
        })

        @render()

    markIncomplete: -> 
        @model.set('completed', 0)
        
        $.ajax({
            type: 'PUT',
            url: '/goals/' + @model.get('id') + '/make_incomplete',
            dataType: 'json'
        })

        @render()