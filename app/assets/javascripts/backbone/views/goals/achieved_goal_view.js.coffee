Bucketlist.Views.Goals ||= {}

class Bucketlist.Views.Goals.AchievedGoalView extends Backbone.View
    template: JST["backbone/templates/goals/achieved_goal"]

    initialize: () ->
        # console.log @model

    render: ->
        @$el.html(@template({goal: @model.toJSON()}))
        return this