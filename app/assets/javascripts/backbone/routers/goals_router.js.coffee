class Bucketlist.Routers.GoalsRouter extends Backbone.Router
  initialize: (options) ->
    @goals = new Bucketlist.Collections.GoalsCollection()
    @goals.reset options.goals

  routes:
    "new"      : "newGoal"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newGoal: ->
    @view = new Bucketlist.Views.Goals.NewView(collection: @goals)
    $("#goals").html(@view.render().el)

  index: ->
    @view = new Bucketlist.Views.Goals.IndexView(goals: @goals)
    $("#goals").html(@view.render().el)

  show: (id) ->
    goal = @goals.get(id)

    @view = new Bucketlist.Views.Goals.ShowView(model: goal)
    $("#goals").html(@view.render().el)

  edit: (id) ->
    goal = @goals.get(id)

    @view = new Bucketlist.Views.Goals.EditView(model: goal)
    $("#goals").html(@view.render().el)
