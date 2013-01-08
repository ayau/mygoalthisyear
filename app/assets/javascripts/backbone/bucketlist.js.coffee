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
    # Bucketlist.userView = new Bucketlist.Views.Users.ShowView()
    # Bucketlist.userRouter = new Bucketlist.Routers.UsersRouter()
    # Bucketlist.userView = new Bucketlist.Views.Users.ShowView()