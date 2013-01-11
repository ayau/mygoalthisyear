Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.CurrentView extends Backbone.View
    template: JST["backbone/templates/goals/current"]

    tagName: 'section'
    className: 'current'

    initialize: () ->
        @goals = @options.goals
        @goals.bind('reset', @addAll)
        @goals.bind('remove', @removeOne)
        @goals.bind('add', @addOne)
        
        # should this be binded to view instead? (multiple bindings)
        @goals.bind('newEvent', @newEvent)
        
        @goal_form_view = new Bucketlist.Views.Goals.FormView()
        @event_form_view = new Bucketlist.Views.Events.FormView()

    addAll: () =>
        @$('.current-goals').empty()
        @goals.each(@addOne)

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.CurrentGoalView({id: goal.id, model : goal})
        @$('.current-goals').prepend(view.render().el)

    removeOne: (goal) =>
        @$('#' + goal.id).remove()

    render: =>
        @$el.html(@template())

        # rendering form
        @$el.prepend(@goal_form_view.render().el)

        @$el.append(@event_form_view.render().el)
        
        @addAll()

        return this

    newEvent: (view) =>
        # goal_id, offset top, did_it_text, is_subgoal, callback
        @event_form_view.newEvent view.model.id, view.$el.position().top, view.$('input[type=submit]').val(), false, () ->
            view.$('.new_event').val('I did it again!')

        # Changing the number on evented
        evented = view.$('.evented')
        
        evented.text(parseInt(evented.text()) + 1)
        evented.show()




