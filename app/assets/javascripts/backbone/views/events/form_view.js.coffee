Bucketlist.Views.Events ||= {}

class Bucketlist.Views.Events.FormView extends Backbone.View
    template: JST["backbone/templates/events/form"]

    eventExtended = false

    events: ->
        'click .close': @closeForm
        'click .event-details': @containerClick
        'submit .event-details': @submitForm

    initialize: ->
        @json = {
            auth_token: $('meta[name="csrf-token"]').attr('content')
        }

    render: ->
        @$el.html(@template(@json))
        return this

    newEvent: (goal_id, offset_top, did_it_text, is_subgoal, callback) ->

        # Check the success?
        $.ajax({
            type: 'POST',
            url: '/events',
            dataType: 'json',
            data:
                goal_id: goal_id
        })

        @eventDetails ?= @$('.event-details')
        
        @eventDetails.find('input[type=button]').val(did_it_text)

        @eventDetails.hide()
        @eventDetails.css('top', offset_top + 38)

        # Offset for subgoals
        if is_subgoal
            @eventDetails.css('left', '165px')
        else
            @eventDetails.css('left', '142px')
            

        # Putting in the correct goal_id
        @eventDetails.find('#event_goal_id').val(goal_id)

        # if not eventExtended
        @eventDetails.animate({
            width: 'toggle'
            height: 'toggle'
            # opacity: 'toggle'
            display: 'block'
        }, 300, 'linear', =>
            @eventDetails.find('textarea').focus()
            @eventExtended = true
            callback()
        )

    closeForm: ->
        @eventDetails ?= @$('.event-details')

        # # Check if form is filled in. Warning?
        if @eventExtended
            @eventDetails.animate({
                width: 'toggle'
                height: 'toggle'
                # opacity: 'toggle'
                display: 'none'
            }, 300, 'linear', =>
                @eventDetails.find('textarea').val('')
                @eventExtended = false
            )

        # easeOutElastic

    isFilledIn: ->
        @eventDetails ?= @$('.event-details')        
        return @eventDetails.find('textarea').val().length > 0

    submitForm: ->
        # Something to indicate form has been submitted?
        @closeForm()

    # Intercept click event
    containerClick: (e) ->
        e.stopPropagation()    

