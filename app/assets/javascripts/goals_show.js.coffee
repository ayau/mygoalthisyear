
$ ->

    search = $('#search')
    search_results = $('#search_results')
    timer = null
    query = ''
    max_results = 10
    more_results = false
    cached_results = []
    last_input = ''
    cached_query = ''

    $('html').live 'click', () ->
        search_results.hide()

    $('.search').live 'click', (event) ->
        event.stopPropagation()
     
    search.focus (e) ->
        performSearch()

    search.keyup (e) ->
        performSearch()

    performSearch = ->
        search_val = search.val()

        search_val = $.trim(search_val)
        
        if search_val.indexOf(cached_query) is 0 and !more_results and cached_results.length > 0
            last_input = search_val
            internal_query last_input
            return

        search_results.empty()
        console.log search_val
        input = search_val
        last_input = input
        
        if input is query or input is ''
            return

        search_results.append '<li><img src="http://www.weathermodule.com/images/loading_dots.gif"/></li>'

        if timer
            window.clearTimeout timer

        timer = window.setTimeout (() -> submit_query input), 300


    submit_query = (input) ->
        query = input
        $.ajax({
            type: "GET",
            url: '/users/search'
            data: {
                search: query
            }
            success: (results) ->
                display_results results, query          
        })

    display_results = (results, query) ->
        search_results.empty()

        if results.length is 0
            search_results.append '<li>No users found..</li>'
        
        if results.length >= max_results
            more_results = true
        else
            more_results = false

        # console.log results

        for r in results
            avatar = r.avatar || 'http://www.ohmyhandmade.com/wp-content/uploads/2011/12/twitter-egg.jpg'
        
            search_results.append('<li><a class="invite_user" user_id="' + r.id + '"><div class="avatar mini" style="background-image: url(' + avatar + ')"></div><p>' + r.name + '</p></a></li>')

        cached_results = results
        cached_query = query
        console.log 'cached_query: ' + query
        search_results.show()

    internal_query = (input) ->
        search_results.empty()
        count = 0
        # console.log cached_results
        for r in cached_results
            if r.name.toLowerCase().indexOf(input.toLowerCase()) isnt -1
                
                avatar = r.avatar || 'http://www.ohmyhandmade.com/wp-content/uploads/2011/12/twitter-egg.jpg'
        
                search_results.append('<li><a class="invite_user" user_id="' + r.id + '"><div class="avatar mini" style="background-image: url(' + avatar + ')"></div><p>' + r.name + '</p></a></li>')

                count = count + 1

        if count is 0
            search_results.append '<li>No users found..</li>'
        
        search_results.show()


    $('.invite_user').live 'click', () ->
        $('#user_id').val($(this).attr('user_id'))
        $('.invite_form').submit()
