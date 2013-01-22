Bucketlist.Views.Users ||= {}

class Bucketlist.Views.Users.UserView extends Backbone.View
    template: JST["backbone/templates/users/user"]

    tagName: 'header'
    className: 'user-header'

    initialize: ->
        @model.set('avatar', @model.get('avatar') || 'http://www.ohmyhandmade.com/wp-content/uploads/2011/12/twitter-egg.jpg')

    render: ->
        @$el.html(@template({user: @model.toJSON()}))
        return this