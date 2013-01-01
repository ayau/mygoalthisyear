
# Repeated code from users_show -> refactor when move to backbone

$ ->    
    # Intercept click event
    $('.quick_goal_form').live 'click', (e) ->
        if !badgeOpened && !colorOpened
            e.stopPropagation()
        
    $('.has-deadline').live 'click', ->
        if $('#goal_has_deadline').is(':checked')
            $('.deadline-form').slideDown('fast')
        else
            $('.deadline-form').slideUp('fast')

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

