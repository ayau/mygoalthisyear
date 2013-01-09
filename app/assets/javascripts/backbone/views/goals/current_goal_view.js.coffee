Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.CurrentGoalView extends Backbone.View
    template: JST["backbone/templates/goals/current_goal"]

    tagName: 'li'
    className: 'goal'

    initialize: ->
        if @completed is 1
            className: 'goal completed'
        else
            className: 'goal'

    # events:
    #     "click .destroy" : "destroy"

    # destroy: () ->
    #     @model.destroy()
    #     this.remove()

    #     return false

    render: ->
        @$el.html(@template({goal: @model.toJSON()}))
        return this
