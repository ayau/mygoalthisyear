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
        checkboxes = @$("input[type='checkbox']")
        selection = {}
        for cb in checkboxes
            selection[$(cb).attr('id')] = ($(cb).attr('checked') is 'checked')
        @trigger 'submit', {goal_id: @goal.id, subgoals: selection}
        @$el.hide()

    closeForm: ->
        @$el.hide()


