#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Bucketlist =
    Models: {}
    Collections: {}
    Routers: {}
    Views: {}

# App init
$ ->
    Bucketlist.appView = new Bucketlist.Views.AppView()

    pathArray = window.location.pathname.split( '/' )
    
    if pathArray.length > 1
        url = pathArray[1]
        if url is 'users'
            Bucketlist.userRouter = new Bucketlist.Routers.UsersRouter()
    Backbone.history.start()