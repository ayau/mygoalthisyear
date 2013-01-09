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

        @goal_form_view = new Bucketlist.Views.Goals.FormView()

    addAll: () =>
        @$('.current-goals').empty()
        @goals.each(@addOne)

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.CurrentGoalView({model : goal})
        @$('.current-goals').prepend(view.render().el)

    removeOne: (goal) =>
        @$('#' + goal.id).parent().remove()

    render: =>
        @$el.html(@template())

        # rendering form
        @$el.prepend(@goal_form_view.render().el)
        
        @addAll()

        return this

