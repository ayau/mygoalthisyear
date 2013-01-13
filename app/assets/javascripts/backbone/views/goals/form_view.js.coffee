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
        @json = {
            color: 'fbcc91'
            fg: '4d2d74'
            badge_url: '/svg/star.svg?color=4d2d74'
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

        # New colors
        # <div style='background: #<%= color %>' class='badge badge-preview'>
        #     <img class='logo' src='<%= badge_url %>' />
        # </div>

        # <input badge_color="fg" badge_id="/svg/star.svg" id="goal_badge" name="goal[badge]" type="hidden" value="<%= badge_url %>">
        # <input id="goal_color" name="goal[color]" type="hidden" value="<%= color %>">
        
        # <div class='cp-icon fg-color' style='background: #<%= fg %>'></div>
        # <div class='cp-icon bg-color' style='background: #<%= color %>'></div>
    
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

        # use svg instead and use svg style: color red to change color. Same for color picker
        $('.badge-preview img').attr('src', url)
        $('#goal_badge').val(url)
        $('#goal_badge').attr('badge_id', id)

    badgeContainerClick: (e) ->
        e.stopPropagation()





