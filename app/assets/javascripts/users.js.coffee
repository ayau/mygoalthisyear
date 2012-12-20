# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->

    bhelper = $('.bucket-helper')

    # Jquery draggable and droppable
    $(".bucket .badge").draggable({
        appendTo: "body"
        scroll: 'false'
        helper: "clone"
        revert: 'invalid'
    })

    bhelper.droppable({
        tolerance: 'touch'
        # hoverClass: "ui-state-hover",
        over: (e, ui) ->
            image = $(ui.draggable).css('background-image')
            
            $('.snapped-badge').addClass('badge')
            $('.snapped-badge').css('background-image', image)
            $('.snapped-badge').css('opacity', 0.5)

        out: (e, ui) ->
            $('.snapped-badge').removeClass('badge')
            $('.snapped-badge').css('background-image', '')

        drop: (e, ui ) ->
            goal_id = $(ui.draggable).attr('id')
            $('#month_goal_id').val(goal_id)
            $('.edit_month').submit()
    })

    # Setting up top position of bucket helper
    bhelper.css('top', $('.bucket').offset().top + 50)

    $(window).scroll (event) ->
        y = $(window).scrollTop();
        
        if y > $('.bucket').offset().top
            bhelper.addClass('fixed')
            bhelper.css('top', 50)
        else
            bhelper.removeClass('fixed')
            bhelper.css('top', $('.bucket').offset().top + 50)
    