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
        @initDraggable()

    addOne: (goal) =>
        view = new Bucketlist.Views.Goals.GoalView({model : goal})
        @$('ul').prepend(view.render().el)

    removeOne: (goal) =>
        @$('#' + goal.id).parent().remove()

    render: =>
        @$el.html(@template())

        # rendering bucket helper
        @$('.bucket-helper').replaceWith(@bucket_helper_view.render().el)
        
        @addAll()

        return this

    initDraggable: () ->
        $(".draggable").draggable({
            appendTo: "body"
            scroll: 'false'
            helper: "clone"
            revert: 'invalid'
        })
