Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.AchievedView extends Backbone.View
    template: JST["backbone/templates/goals/achieved"]

    tagName: 'section'
    className: 'achievements'

    events: ->
        'click .hide-achievements': @hideAchievements

    initialize: () ->
        @goals = @options.goals
        @goals.bind('reset', @addAll)
        @goals.bind('remove', @removeOne)
        @goals.bind('add', @addOne)

    addAll: () =>
        @$('.slider').empty()
        @goals.each(@addOne)
        @display()

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.AchievedGoalView({id: goal.id, model : goal})
        @$('.slider').prepend(view.render().el)
        @display()

    removeOne: (goal) =>
        @$('#' + goal.id).remove()
        @display()

    render: =>
        @$el.html(@template({user_id: Bucketlist.me.id}))

        @addAll()
        
        return this

    display: ->
        if @goals.length is 0
            @$el.hide()
        else
            @$el.show()

    hideAchievements: () ->
        @$('.slider').slideToggle 'slow', () ->
            if $('.achievements').hasClass('hidden')
                $('.achievements').removeClass('hidden')
                $('.hide-achievements').text('hide')
            else
                $('.achievements').addClass('hidden')
                $('.hide-achievements').text('show')
