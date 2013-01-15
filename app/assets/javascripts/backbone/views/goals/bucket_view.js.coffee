Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.BucketView extends Backbone.View
    template: JST["backbone/templates/goals/bucket"]

    tagName: 'section'
    className: 'bucket'
    
    initialize: () ->
        @goals = @options.goals
        @goals.bind('reset', @addAll)
        @goals.bind('remove', @removeOne)
        @goals.bind('add', @addOne)

        @bucket_helper_view = new Bucketlist.Views.Users.BucketHelperView()

    addAll: () =>
        @$('ul').empty()
        @goals.each(@addOne)

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.GoalView({id: goal.id, model : goal})
        @$('ul').prepend(view.render().el)
        @initDraggable(view.$(".draggable"))

    removeOne: (goal) =>
        @$('#' + goal.id).remove()

    render: =>
        @$el.html(@template())

        # rendering bucket helper
        @$('.bucket-helper').replaceWith(@bucket_helper_view.render().el)
        
        @addAll()

        return this

    initDraggable: (elem) ->
        elem.draggable({
            appendTo: "body"
            scroll: 'false'
            helper: "clone"
            revert: 'invalid'
        })
