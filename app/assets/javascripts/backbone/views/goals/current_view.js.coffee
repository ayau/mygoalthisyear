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

        @goals.bind('chooseSubgoals', @chooseSubgoals)
        
        @goal_form_view = new Bucketlist.Views.Goals.FormView()
        @event_form_view = new Bucketlist.Views.Events.FormView()
        @choose_subgoal_view = new Bucketlist.Views.Goals.ChooseView()

        @choose_subgoal_view.bind('submit', @chooseSubmit)

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

        @$el.append(@choose_subgoal_view.render().el)
        
        @addAll()

        return this

    newEvent: (view, top, is_subgoal) =>

        if !@event_form_view.eventExtended
            
            # goal_id, offset top, did_it_text, is_subgoal, callback
            @event_form_view.newEvent view.model.id, top, view.$('input[type=submit]').val(), is_subgoal, () ->
                view.$('.new_event').val('I did it again!')

            # Changing the number on evented
            evented = view.$('.evented')

            # Adds 'completed' when event is created. Use view.render() when the issue of image flashing is fixed 
            if parseInt(evented.text()) is 0
                view.$('.giveup').before("<a class='mark-complete'>Mark as comleted</a> | ")

            view.model.set('events_in_month', parseInt(evented.text()) + 1)
            
            evented.text(parseInt(evented.text()) + 1)
            evented.show()

    chooseSubgoals: (goal) =>
        @choose_subgoal_view.goal = goal
        @choose_subgoal_view.render().$el.show()

    chooseSubmit: (data) =>
        @goals.get(data.goal_id).changeSubgoals(data.subgoals)


