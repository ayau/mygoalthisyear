Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.CurrentGoalView extends Backbone.View
    template: JST["backbone/templates/goals/current_goal"]

    tagName: 'li'
    className: 'goal'

    initialize: ->
        @model.bind('resetSubgoals', @resetSubgoals)

        if @options.is_subgoal
            @template = JST["backbone/templates/goals/subgoal"]
        else
            @subgoals = new Bucketlist.Collections.GoalsCollection(@model.get('subgoals'))

            @subgoals.bind('reset', @addAll)
            @subgoals.bind('remove', @removeOne)
            @subgoals.bind('add', @addOne)
            @subgoals.bind('subEvent', @newSubEvent)
        
    events: ->
        'click .giveup': @giveUp
        'click .new_event': @newEvent
        'click .mark-complete': @markComplete
        'click .mark-incomplete': @markIncomplete
        'click .choose-subgoals': @chooseSubgoals

    render: ->
        console.log @model.get('completed' == 1)
        if @model.get('completed') < 100
            @$el.addClass 'completed'
        else
            @$el.removeClass 'completed'

        @$el.html(@template({goal: @model.toJSON()}))

        @renderSubgoals()

        return this

    addAll: =>
        @$('.subgoals').empty()
        @subgoals.each(@addOne)

    addOne: (subgoal) =>
        if subgoal.get('is_current') == 1
            view = new Bucketlist.Views.Goals.CurrentGoalView({id: subgoal.id, model : subgoal, className: 'sub goal', is_subgoal: true})
            @$('.subgoals').prepend(view.render().el)

    removeOne: (subgoal) =>
        @$('#' + goal.id).remove()

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
        if @$el.hasClass('sub')
            @model.collection.trigger 'subEvent', @
        else if @model.get('subgoals').length is 0
            @model.collection.trigger 'newEvent', @, @$el.position().top, false

    # push the event from subgoal to collection
    newSubEvent: (view) =>
        @model.collection.trigger 'newEvent', view, view.$el.position().top + @$el.position().top, true

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

    chooseSubgoals: ->
        @model.collection.trigger 'chooseSubgoals', @model

    renderSubgoals: =>
        if @subgoals
            @addAll()

    resetSubgoals: =>

        # Edit instead of recreate?
        @subgoals = new Bucketlist.Collections.GoalsCollection(@model.get('subgoals'))

        @subgoals.bind('reset', @addAll)
        @subgoals.bind('remove', @removeOne)
        @subgoals.bind('add', @addOne)
        @subgoals.bind('subEvent', @newSubEvent)

        @renderSubgoals()

