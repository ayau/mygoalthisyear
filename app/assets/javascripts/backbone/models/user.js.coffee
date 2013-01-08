class Bucketlist.Models.User extends Backbone.Model
    paramRoot: 'user'

    defaults:
        name: ''
        avatar: 'http://www.ohmyhandmade.com/wp-content/uploads/2011/12/twitter-egg.jpg'
        auto_add: 0

class Bucketlist.Models.Me extends Backbone.Model
    urlRoot: '/api/me'

    initialize: ->
        @fetch({
            error: ->
                Bucketlist.me.trigger 'unauthorized'
        })


class Bucketlist.Collections.UsersCollection extends Backbone.Collection
    model: Bucketlist.Models.User
    url: '/users'
