Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.FormView extends Backbone.View
    template: JST["backbone/templates/goals/form"]

    optionsExtended: false

    events: ->
        # 'submit form': @submit
        'ajax:success': @createGoal
        'click .more-options': @optionsClick

    initialize: ->
        @json = {
            color: 'fbcc91'
            fg: '4d2d74'
            badge_url: '/svg/star.svg?color=4d2d74'
            auth_token: $('meta[name="csrf-token"]').attr('content')
            auto_add: Bucketlist.me.get('auto_add')
        }

        # function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},

    # update: (e) ->
    #     e.preventDefault()
    #     e.stopPropagation()

    #     @model.save(null,
    #         success: (goal) =>
    #             @model = goal
    #             window.location.hash = "/#{@model.id}"
    #     )

    render: ->
        @$el.html(@template(@json))

        # this.$("form").backboneLink(@model)

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
  


        

    # # Intercept click event
    # $('.quick_goal_form').live 'click', (e) ->
    #     if !badgeOpened && !colorOpened
    #         e.stopPropagation()
        
    # $('.has-deadline').live 'click', ->
    #     if $('#goal_has_deadline').is(':checked')
    #         $('.deadline-form').slideDown('fast')
    #     else
    #         $('.deadline-form').slideUp('fast')


    # # repeated code
    # $('#goal_name').live 'focus blur',  (e) ->
    #     if e.type is 'focusin' and not optionsExtended
    #         $('.quick_goal_form').addClass('extended')
    #         $('.extra-options').fadeIn()
    #         $('.more-options').text('- less options')
    #         # Description add focus
    #         optionsExtended = !optionsExtended






