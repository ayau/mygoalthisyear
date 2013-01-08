Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.BucketView extends Backbone.View
    template: JST["backbone/templates/goals/bucket"]

    tagName: 'section'
    className: 'bucket'
    
    initialize: () ->
        # @el = $('.bucket')
        @goals = @options.goals
        @goals.bind('reset', @addAll)

    addAll: () =>
        @$('ul').empty()
        @goals.each(@addOne)
        @initDraggable()

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.GoalView({model : goal})
        @$('ul').append(view.render().el)

    render: =>
        @$el.html(@template())
        @addAll()

        return this

    initDraggable: () ->
        $(".draggable").draggable({
            appendTo: "body"
            scroll: 'false'
            helper: "clone"
            revert: 'invalid'
        })
