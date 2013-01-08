Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.BucketHelperView extends Backbone.View
    template: JST["backbone/templates/users/bucket_helper"]

    tagName: 'section'
    className: 'bucket-helper'

    initialize: ->
        $(@el).droppable({
            tolerance: 'touch'
            # hoverClass: "ui-state-hover",
            over: (e, ui) ->
                badge = $(ui.draggable)
                
                $('.snapped-badge').addClass('badge')
                $('.snapped-badge').css('background', badge.css('background'))
                $('.snapped-badge').css('opacity', 0.5)
                $('.snapped-badge').find('img').attr('src', badge.find('img').attr('src'))
                $('.snapped-badge').find('img').show()

            out: (e, ui) ->
                $('.snapped-badge').removeClass('badge')
                $('.snapped-badge').css('background', '')
                $('.snapped-badge').find('img').hide()

            drop: (e, ui ) ->
                goal_id = $(ui.draggable).attr('id')
                $('#user_goal_id').val(goal_id)
                $('.edit_user').submit()
        })

        # Setting up top position of bucket helper
        $(@el).css('top', $('.bucket').offset().top + 20)

        # If window is resized, need to recalculate
        bucketLeft = $('.bucket').offset().left + $('.bucket').width() - $(@el).width() + 12

        $(window).scroll (event) ->

            y = $(window).scrollTop();
            console.log $('.bucket').offset().top
            console.log y
            if y > $('.bucket').offset().top + 20
                $(@el).addClass('fixed')
                $(@el).css('top', 50)
                $(@el).css('left', bucketLeft)

            else
                $(@el).removeClass('fixed')
                $(@el).css('top', $('.bucket').offset().top + 20)
                $(@el).css('left', 682);


    render: ->
        @$el.html(@template())
        return this