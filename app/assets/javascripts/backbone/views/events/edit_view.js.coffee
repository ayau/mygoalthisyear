Bucketlist.Views.Events ||= {}

class Bucketlist.Views.Events.EditView extends Backbone.View
  template: JST["backbone/templates/events/edit"]

  events:
    "submit #edit-events": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (events) =>
        @model = events
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
