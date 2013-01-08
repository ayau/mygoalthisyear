Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.ShowView extends Backbone.View
    template: JST["backbone/templates/users/show"]

    # initialize: ->
        
        

    render: ->
        @$el.html(@template(@model.toJSON() ))
        return this
