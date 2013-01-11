Bucketlist.Views.Events ||= {}

class Bucketlist.Views.Events.NewView extends Backbone.View
  template: JST["backbone/templates/events/new"]

  events:
    "submit #new-events": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (events) =>
        @model = events
        window.location.hash = "/#{@model.id}"

      error: (events, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
