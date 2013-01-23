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

        # Is current and stuff.. events_in_month
        events_in_month: 0
        completed: 0

        subgoals: []

    changeSubgoals: (subgoals) ->
        for s in @get('subgoals')
            if subgoals[s.id]
                s.is_current = 1
            else
                s.is_current = 0
        @trigger 'resetSubgoals'

class Bucketlist.Collections.GoalsCollection extends Backbone.Collection
    model: Bucketlist.Models.Goal
    url: '/goals'

    initialize: (models, options) ->
        if options
            @url = '/api/users/' + options.user_id + '/goals/' + options.route 
            @fetch()