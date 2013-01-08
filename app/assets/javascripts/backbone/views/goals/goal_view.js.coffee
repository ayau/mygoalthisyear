Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.GoalView extends Backbone.View
    template: JST["backbone/templates/goals/goal"]

    tagName: 'li'
    className: 'goal'

    # events:
    #     "click .destroy" : "destroy"

    # tagName: "tr"

    # destroy: () ->
    #     @model.destroy()
    #     this.remove()

    #     return false

    render: ->
        @$el.html(@template({goal: @model.toJSON()}))
        return this
