# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->

    # Bucket Helper -----------------------------------------
    bhelper = $('.bucket-helper')

    # Jquery draggable and droppable
    $(".draggable").draggable({
        appendTo: "body"
        scroll: 'false'
        helper: "clone"
        revert: 'invalid'
    })

    bhelper.droppable({
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
        if !badgeOpened && !colorOpened
            e.stopPropagation()
        
    $('.has-deadline').live 'click', ->
        if $('#goal_has_deadline').is(':checked')
            $('.deadline-form').slideDown('fast')
        else
            $('.deadline-form').slideUp('fast')


    # repeated code
    $('#goal_name').focus () ->
        if not optionsExtended
            $('.quick_goal_form').addClass('extended')
            $('.extra-options').fadeIn()
            $('.more-options').text('- less options')
            # Description add focus
            optionsExtended = !optionsExtended

    # Badge stuff
    badge = $('.badge-preview')
    badgeLogo = badge.find('img')
    badgeOpened = false

    badge.live 'click', () ->
        $('.badge-select').fadeIn 'slow', () ->
            badgeOpened = true
        
    $('.badge-select li').live 'click', () ->
        $('.badge-select .selected').removeClass('selected')
        $(this).addClass('selected')

        id = $(this).find('img').attr('src')
        color = $('#goal_badge').attr('badge_color')
        url = id + '?color=' + color

        badgeLogo.attr('src', url)
        $('#goal_badge').val(url)
        $('#goal_badge').attr('badge_id', id)

    $('.badge-select').live 'click', (e) ->
        e.stopPropagation()


    # Color picker ------------------

    colorSelect = 'fg'

    # create a colour picker for the node with the id 'colourPicker'
    colorPicker = new ColourPicker(document.getElementById('colourPicker'), '/assets/ColorPickerImages/', new RGBColour(255, 0, 255));

    colorPicker.addChangeListener () ->
        rgb = colorPicker.getColour().getRGB()
        hex = (Math.round(rgb.r) * 65536 + Math.round(rgb.g) * 256 + Math.round(rgb.b)).toString(16)
        
        if colorSelect == 'fg'
            $('.fg-color').css('background', '#' + hex)
            $('#goal_badge').attr('badge_color', hex)

            id = $('#goal_badge').attr('badge_id')
            url = id + '?color=' + hex

            $('#goal_badge').val(url)

            badgeLogo.attr('src', url)
        else
            $('.bg-color').css('background', '#' + hex)
            $('#goal_color').val(hex)

            badge.css('background', '#' + hex)

    colorOpened = false

    $('.cp-icon').live 'click', (e) ->
        if colorOpened
            e.stopPropagation()

        $('.color-picker').fadeIn 'slow', () ->
            colorOpened = true

        if $(this).hasClass('bg-color')
            colorSelect = 'bg'
            rgb = hexToRgb($('#goal_color').val())
        else
            colorSelect = 'fg'
            rgb = hexToRgb($('#goal_badge').attr('badge_color'))

        colorPicker.setColour(new RGBColour(rgb.r, rgb.g, rgb.b))

    hexToRgb = (hex) ->
        result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        
        if !result
            return null

        return {
            r: parseInt(result[1], 16)
            g: parseInt(result[2], 16)
            b: parseInt(result[3], 16)
        }


    $('.color-picker').live 'click', (e) ->
        e.stopPropagation()


    # Achievements ---------------------------------------
    
    $('.hide-achievements').live 'click', ->
        $('.slider').slideToggle 'slow', () ->
            if $('.achievements').hasClass('hidden')
                $('.achievements').removeClass('hidden')
                $('.hide-achievements').text('hide')
            else
                $('.achievements').addClass('hidden')
                $('.hide-achievements').text('show')


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
        if badgeOpened
            $('.badge-select').fadeOut()
            badgeOpened = false
            return

        if colorOpened
            $('.color-picker').fadeOut()
            colorOpened = false
            return

        # Automatically hides more options of add a goal
    # Don't hide if stuff's been filled in?
        if optionsExtended
            $('.more-options').click()
        
    # Don't hide if form filled in
        if eventExtended
            $('.close').click()



    # Alternate SVG color loading (without replacing src) 
    # <script>
    # //<![CDATA[
            
    #     // wait until all the resources are loaded
    #     window.addEventListener("load", findSVGElements, false);
        
    #     // fetches the document for the given embedding_element
    #     function getSubDocument(embedding_element)
    #     {
    #         if (embedding_element.contentDocument) 
    #         {
    #             return embedding_element.contentDocument;
    #         } 
    #         else 
    #         {
    #             var subdoc = null;
    #             try {
    #                 subdoc = embedding_element.getSVGDocument();
    #             } catch(e) {}
    #             return subdoc;
    #         }
    #     }
                
    #     function findSVGElements()
    #     {
    #         var elms = document.querySelectorAll("embed");
    #         for (var i = 0; i < elms.length; i++)
    #         {
    #             var subdoc = getSubDocument(elms[i])
    #             if (subdoc)
    #                 subdoc.getElementById("svgbar").setAttribute("fill", "lime");
    #         }
    #     }
    #     //]]>
    # </script>
