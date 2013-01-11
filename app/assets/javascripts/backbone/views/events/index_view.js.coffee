Bucketlist.Views.Events ||= {}

class Bucketlist.Views.Events.IndexView extends Backbone.View
  template: JST["backbone/templates/events/index"]

  initialize: () ->
    @options.events.bind('reset', @addAll)

  addAll: () =>
    @options.events.each(@addOne)

  addOne: (events) =>
    view = new Bucketlist.Views.Events.EventsView({model : events})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(events: @options.events.toJSON() ))
    @addAll()

    return this
