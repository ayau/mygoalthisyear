Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.BucketHelperView extends Backbone.View
    template: JST["backbone/templates/users/bucket_helper"]

    tagName: 'section'
    className: 'bucket-helper'

    initialize: ->
        @initDroppable()

        # If window is resized, need to recalculate fixed position
        # $(window).resize?
        bucketLeft = $('.bucket').width() + 20

        $(window).scroll (event) =>

            y = $(window).scrollTop();

            if y > $('.bucket').offset().top - 30
                $(@el).addClass('fixed')
                $(@el).css('top', 50)
                $(@el).css('left', bucketLeft)

            else
                $(@el).removeClass('fixed')
                $(@el).css('top', 20)
                $(@el).css('left', 35)


    render: ->
        @$el.html(@template())
        return this

    initDroppable: ->
                
        $(@el).droppable({
            tolerance: 'touch'
            # hoverClass: "ui-state-hover",
            over: @showSnappedBadge

            out: @hideSnappedBadge

            drop: @dropHandler
        })

    dropHandler: (e, ui) =>
        goal_id = $(ui.draggable).attr('goal_id')
        
        $.ajax({
            type: 'PUT',
            url: '/users/' + Bucketlist.me.id + '/add_goal',
            dataType: 'json',
            data:
                goal_id: goal_id
            success: (results) =>
                @hideSnappedBadge()
                @trigger 'add_goal:success', goal_id
        })

    showSnappedBadge: (e, ui) ->
        badge = $(ui.draggable)
                
        snappedBadge = $('.snapped-badge')
                
        snappedBadge.addClass('badge')
        snappedBadge.css('background', badge.css('background'))
        snappedBadge.css('opacity', 0.5)
        snappedBadge.find('img').attr('src', badge.find('img').attr('src'))
        snappedBadge.find('img').show()

    hideSnappedBadge: () ->
        snappedBadge = $('.snapped-badge')
                
        snappedBadge.removeClass('badge')
        snappedBadge.css('background', '')
        snappedBadge.find('img').hide()



