class Bucketlist.Models.Goal extends Backbone.Model
    paramRoot: 'goal'

    defaults:
        name: null
        created_at: null
        points: null
        description: null
        deadline: null
        has_deadline: null
        badge: null
        color: null
        owner_id: null
        parent_id: null

class Bucketlist.Collections.GoalsCollection extends Backbone.Collection
    model: Bucketlist.Models.Goal
    url: '/goals'
