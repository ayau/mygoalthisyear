class Bucketlist.Views.AppView extends Backbone.View

    initialize: ->
        _.bindAll @

        Bucketlist.me = new Bucketlist.Models.Me

        Bucketlist.me.bind 'change', @UserLoaded
        Bucketlist.me.bind 'unauthorized', @UserUnauthorized

    UserLoaded: ->
        headerView = new Bucketlist.Views.Layout.HeaderView()
        $(".header").html(headerView.render().el)

    UserUnauthorized: ->
        Bucketlist.me = null
        @UserLoaded()

