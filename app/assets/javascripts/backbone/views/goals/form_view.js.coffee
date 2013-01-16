Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.FormView extends Backbone.View
    template: JST["backbone/templates/goals/form"]

    optionsExtended: false
    colorOpened: false
    badgeOpened: false

    events: ->
        # 'submit form': @submit
        'ajax:success': @createGoal
        'click .more-options': @optionsClick
        'focus #goal_name': @onFocus
        'click .has-deadline': @deadlineClick
        
        'click .cp-icon': @cpIconClick
        'click .color-picker': @colorPickerClick
        'click .quick_goal_form': @formClick

        'click .badge-preview': @badgeClick
        'click .badge-select li': @badgeSelect
        'click .badge-select': @badgeContainerClick

    initialize: ->
        color = Math.floor(Math.random()*16777215).toString(16)
        fg = @generate_color(color)
        @json = {
            color: color
            fg: fg
            badge_url: '/svg/star.svg?color='+ fg
            auth_token: $('meta[name="csrf-token"]').attr('content')
            auto_add: Bucketlist.me.get('auto_add')
        }
        # function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},

    render: ->
        @$el.html(@template(@json))

        # this.$("form").backboneLink(@model)
        @initColorPicker()

        return this

    createGoal: (event, data) ->
        goal = new Bucketlist.Models.Goal(data)

        @clearForm()

        # Smarter way to get auto_add. Form may change. Maybe send the whole goal + is_current from server?
        @trigger 'new_goal:success', goal, $('#goal_user_auto_add').val()

    clearForm: ->
        @$('#goal_name').val('')
        @$('#goal_points').val('10')
        @$('#goal_description').val('')
        @$('#goal_has_deadline').prop("checked", false)
        @$('.deadline-form').slideUp()

        # Close the form
        @optionsClick()
    
    optionsClick: ->
        if not @optionsExtended
            $('.quick_goal_form').addClass('extended')
            $('.extra-options').fadeIn()
            $('.more-options').text('- less options')
            # Description add focus
        else
            $('.quick_goal_form').removeClass('extended')
            $('.extra-options').hide()
            $('.more-options').text('+ more options')
            $('#goal_name').blur() # unfocus the form after submission

        @optionsExtended = !@optionsExtended
  
    onFocus: ->
        if not @optionsExtended
            $('.quick_goal_form').addClass('extended')
            $('.extra-options').fadeIn()
            $('.more-options').text('- less options')
            
            @optionsExtended = !@optionsExtended

    deadlineClick: ->
        if $('#goal_has_deadline').is(':checked')
            $('.deadline-form').slideDown('fast')
        else
            $('.deadline-form').slideUp('fast')

    # # Intercept click event
    formClick: (e) ->
        if !@badgeOpened && !@colorOpened
            e.stopPropagation()

    initColorPicker: ->

        @badge = @$('.badge-preview')
        @badgeLogo = @badge.find('img')

        @colorSelect = 'fg'

        # create a colour picker for the node with the id 'colourPicker'
        @colorPicker = new ColourPicker(@$('#colourPicker')[0], '/assets/ColorPickerImages/', new RGBColour(255, 0, 255))

        @colorPicker.addChangeListener () =>

            rgb = @colorPicker.getColour().getRGB()
            hex = (Math.round(rgb.r) * 65536 + Math.round(rgb.g) * 256 + Math.round(rgb.b)).toString(16)
            
            while hex.length < 6
                hex = '0' + hex

            if @colorSelect is 'fg'
                $('.fg-color').css('background', '#' + hex)
                $('#goal_badge').attr('badge_color', hex)

                id = $('#goal_badge').attr('badge_id')
                url = id + '?color=' + hex

                $('#goal_badge').val(url)

                @badgeLogo.attr('src', url)
            else
                $('.bg-color').css('background', '#' + hex)
                $('#goal_color').val(hex)

                @badge.css('background', '#' + hex)


    colorPickerClick: (e) ->
        if @colorOpened
            e.stopPropagation()

    cpIconClick: (e) ->
        if !@badgeOpened
            e.stopPropagation()

        @$('.color-picker').fadeIn 'slow', () =>
            @colorOpened = true

        if $(e.currentTarget).hasClass('bg-color')
            @colorSelect = 'bg'
            rgb = @hexToRgb($('#goal_color').val())
        else
            @colorSelect = 'fg'
            rgb = @hexToRgb($('#goal_badge').attr('badge_color'))

        @colorPicker.setColour(new RGBColour(rgb.r, rgb.g, rgb.b))


    hexToRgb: (hex) ->
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

    badgeClick: ->
        @$('.badge-select').fadeIn 'slow', () =>
            @badgeOpened = true
        
    badgeSelect: (e) ->
        selected = $(e.currentTarget)
        
        $('.badge-select .selected').removeClass('selected')
        selected.addClass('selected')

        id = '/svg/' + selected.attr('badge_id') + '.svg'
        color = $('#goal_badge').attr('badge_color')
        url = id + '?color=' + color

        $('.badge-preview').html(selected.html())
        svg = $('.badge-preview').find('svg')
        svg.attr('width', '53px')
        svg.attr('height', '53px')
        svg.attr('class', 'logo')
        svg.attr('fill', '#' + color)
        svg.find('path').attr('fill', '#' + color)

        $('#goal_badge').val(url)
        $('#goal_badge').attr('badge_id', id)

    badgeContainerClick: (e) ->
        e.stopPropagation()

    # Color stuff
    generate_color: (c) ->

        color = Math.floor(Math.random()*16777215).toString(16)

        while @color_distance(c, color) < 180
            color = Math.floor(Math.random()*16777215).toString(16)

        return color
    
    color_distance: (c0, c1) ->
        rgb0 = @hex_to_rgb(c0)
        rgb1 = @hex_to_rgb(c1)

        luv0 = @rgb_to_luv(rgb0)
        luv1 = @rgb_to_luv(rgb1)

        return Math.sqrt(Math.pow(luv0['l'] - luv1['l'], 2) + Math.pow(luv0['u'] - luv1['u'], 2) + Math.pow(luv0['v'] - luv1['v'], 2))

    hex_to_rgb: (h) ->
        m = /(..)(..)(..)/.exec(h)
        
        return {
            r: parseInt(m[1], 16)
            g: parseInt(m[2], 16)
            b: parseInt(m[3], 16)
        }

    rgb_to_luv: (rgb) ->
        xyz = @rgb_to_xyz(rgb)
        return @xyz_to_luv(xyz)

    xyz_to_luv: (xyz) ->
        x = xyz['x']
        y = xyz['y']
        z = xyz['z']

        var_U = ( 4 * x ) / ( x + ( 15 * y ) + ( 3 * z ) )
        var_V = ( 9 * y ) / ( x + ( 15 * y ) + ( 3 * z ) )

        var_Y = y / 100

        if var_Y > 0.008856 
            var_Y = Math.pow(var_Y, (1/3))
        else
            var_Y = 7.787 * var_Y  +  16 / 116 

        ref_x =  95.047        #Observer= 2°, Illuminant= D65
        ref_y = 100.000
        ref_z = 108.883

        ref_U = ( 4 * ref_x ) / ( ref_x + ( 15 * ref_y ) + ( 3 * ref_z ) )
        ref_V = ( 9 * ref_y ) / ( ref_x + ( 15 * ref_y ) + ( 3 * ref_z ) )

        l = ( 116 * var_Y ) - 16
        
        return {
            l: l
            u: 13 * l * ( var_U - ref_U )
            v: 13 * l * ( var_V - ref_V )
        }

    rgb_to_xyz: (rgb) ->
        var_R = ( rgb['r'].to_f / 255 )        # R from 0 to 255
        var_G = ( rgb['g'].to_f / 255 )        # G from 0 to 255
        var_B = ( rgb['b'].to_f / 255 )        # B from 0 to 255
        
        if var_R > 0.04045 
            var_R = Math.pow((( var_R + 0.055 ) / 1.055 ), 2.4)
        else                   
            var_R = var_R / 12.92
    

        if var_G > 0.04045 
            var_G = Math.pow((( var_G + 0.055 ) / 1.055 ), 2.4)
        else                   
            var_G = var_G / 12.92

        if var_B > 0.04045 
            var_B = Math.pow((( var_B + 0.055 ) / 1.055 ), 2.4)
        else                   
            var_B = var_B / 12.92

        var_R = var_R * 100
        var_G = var_G * 100
        var_B = var_B * 100

        # Observer. = 2°, Illuminant = D65
        return {
            x: var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
            y: var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
            z: var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505
        }





