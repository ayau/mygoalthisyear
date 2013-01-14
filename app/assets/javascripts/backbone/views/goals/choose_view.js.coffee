Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.ChooseView extends Backbone.View
    template: JST["backbone/templates/goals/choose"]

    tagName: 'section'
    className: 'choose-form'

    events: ->
        'click .close': @closeForm
        'submit form': @submitForm
    
    # initialize: () ->

    render: ->
        if (@goal)
            @$el.html(@template({goal: @goal.toJSON(), auth_token: $('meta[name="csrf-token"]').attr('content')}))
        return this

    submitForm: ->
        @$el.hide()

    closeForm: ->
        @$el.hide()


