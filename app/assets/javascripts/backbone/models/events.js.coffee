class Bucketlist.Models.Events extends Backbone.Model
  paramRoot: 'event'

  defaults:
    post: null
    created_at: null
    updated_at: null

class Bucketlist.Collections.EventsCollection extends Backbone.Collection
  model: Bucketlist.Models.Events
  url: '/events'
