Bucketlist.Views.Layout ||= {}

class Bucketlist.Views.Layout.HeaderView extends Backbone.View
    template: JST["backbone/templates/layout/header"]

    render: ->

        if Bucketlist.me?
            json = Bucketlist.me.toJSON()
        else
            json = null
        
        @$el.html(@template({current_user: json}))

        return @
