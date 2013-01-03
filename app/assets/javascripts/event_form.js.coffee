
# repeated code. Remove when move to backbone

$ ->
    eventDetails = $('.event-details')
    eventExtended = false

    $('.new_event').submit () ->

        article = $(this).parent()
        
        
        ididit = article.find('input[type=submit]').val()
        eventDetails.find('input[type=button]').val(ididit)

        eventDetails.hide()

        # different
        eventDetails.css('top', $(this).offset().top - 61)

        # Offset for subgoals

        # Different from other repeated code
        eventDetails.css('left', '115px')

        # if article.parent().hasClass('sub')
        #     eventDetails.css('left', '165px')
        # else
        #     eventDetails.css('left', '142px')
            

        # Putting in the correct goal_id
        eventDetails.find('#event_goal_id').val(article.find('#event_goal_id').val())

        # if not eventExtended
        eventDetails.animate({
            width: 'toggle'
            height: 'toggle'
            # opacity: 'toggle'
            display: 'block'
        }, 300, 'linear', ->
            eventDetails.find('textarea').focus()
            eventExtended = true
        )

        # Changing the number on evented
        evented = article.parent().find('.evented')
        
        evented.text(parseInt(evented.text()) + 1)
        evented.show()


    $('.close').live 'click', ->

        # Check if form is filled in. Warning?
        if eventExtended
            eventDetails.animate({
                width: 'toggle'
                height: 'toggle'
                # opacity: 'toggle'
                display: 'none'
            }, 300, 'linear', ->
                eventExtended = false
            )

        # easeOutElastic

    # Intercept click event
    eventDetails.live 'click', (e) ->
        e.stopPropagation()    

    # Document click event -------------------------------
    $(document).live 'click', ->
    # Don't hide if form filled in
        if eventExtended
            $('.close').click()
