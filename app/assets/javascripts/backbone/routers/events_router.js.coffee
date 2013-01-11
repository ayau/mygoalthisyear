class Bucketlist.Routers.EventsRouter extends Backbone.Router
  initialize: (options) ->
    @events = new Bucketlist.Collections.EventsCollection()
    @events.reset options.events

  routes:
    "new"      : "newEvents"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newEvents: ->
    @view = new Bucketlist.Views.Events.NewView(collection: @events)
    $("#events").html(@view.render().el)

  index: ->
    @view = new Bucketlist.Views.Events.IndexView(events: @events)
    $("#events").html(@view.render().el)

  show: (id) ->
    events = @events.get(id)

    @view = new Bucketlist.Views.Events.ShowView(model: events)
    $("#events").html(@view.render().el)

  edit: (id) ->
    events = @events.get(id)

    @view = new Bucketlist.Views.Events.EditView(model: events)
    $("#events").html(@view.render().el)
