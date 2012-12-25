# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->

    # Bucket Helper -----------------------------------------
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
    bhelper.css('top', $('.bucket').offset().top + 20)

    # If window is resized, need to recalculate
    bucketLeft = $('.bucket').offset().left + $('.bucket').width() - bhelper.width() + 12

    $(window).scroll (event) ->
        y = $(window).scrollTop();
        
        if y > $('.bucket').offset().top + 20
            bhelper.addClass('fixed')
            bhelper.css('top', 50)
            bhelper.css('left', bucketLeft)

        else
            bhelper.removeClass('fixed')
            bhelper.css('top', $('.bucket').offset().top + 20)
            bhelper.css('left', 682);

    # Quick add form -------------------------------------
    
    optionsExtended = false

    $('.more-options').live 'click', ->

        if not optionsExtended
            $('.quick_goal_form').addClass('extended')
            $('.extra-options').fadeIn()
            $('.more-options').text('- less options')
            # Description add focus
        else
            $('.quick_goal_form').removeClass('extended')
            $('.extra-options').hide()
            $('.more-options').text('+ more options')

        optionsExtended = !optionsExtended

    # Intercept click event
    $('.quick_goal_form').live 'click', (e) ->
        e.stopPropagation()

    $('.has-deadline').live 'click', ->
        if $('#goal_has_deadline').is(':checked')
            $('.deadline-form').slideDown('fast')
        else
            $('.deadline-form').slideUp('fast')


    # Event details form ---------------------------------

    eventDetails = $('.event-details')
    eventExtended = false

    $('.new_event').submit () ->

        article = $(this).parent().parent()
        
        ididit = article.find('input[type=submit]').val()
        eventDetails.find('input[type=button]').val(ididit)

        eventDetails.hide()
        eventDetails.css('top', $(this).offset().top - 51)

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
        # Automatically hides more options of add a goal
    # Don't hide if stuff's been filled in?
        if optionsExtended
            $('.more-options').click()
        
    # Don't hide if form filled in
        if eventExtended
            $('.close').click()


    # Badges ----------------------------------------------
    # # wait until all the resources are loaded
    # window.addEventListener("load", findSVGElements, false)
    
    # # fetches the document for the given embedding_element
    # getSubDocument = (embedding_element) ->
    #     if (embedding_element.contentDocument) 
    #         return embedding_element.contentDocument
    #     else
    #         subdoc = null
    #         try 
    #             subdoc = embedding_element.getSVGDocument()
    #         catch e 
    #             console.log e
    #         return subdoc

            
    # findSVGElements = () ->
    #     console.log 'here'
    #     elements = document.querySelectorAll("embed");
    #     console.log elements
    #     for elem in elements
    #         subdoc = getSubDocument(elem)
    #         if (subdoc)
    #             subdoc.getElementById("svgbar").setAttribute("fill", "lime")
        
    # findSVGElements()

    