class Bucketlist.Routers.UsersRouter extends Backbone.Router
    
    initialize: (options) ->
        # @users = new Bucketlist.Collections.UsersCollection()
        # @users.reset options.users

    routes:
        ":id/edit" : "edit"
        ":id"      : "show"
        ".*"       : "default"

    default: ->
        @view = new Bucketlist.Views.Users.ShowView(model: Bucketlist.me)
        $("#users").html(@view.render().el)

    show: (id) ->
        user = @users.get(id)

        @view = new Bucketlist.Views.Users.ShowView(model: user)
        $("#users").html(@view.render().el)

    edit: (id) ->
        user = @users.get(id)

        @view = new Bucketlist.Views.Users.EditView(model: user)
        $("#users").html(@view.render().el)
