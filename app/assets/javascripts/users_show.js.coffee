
$ ->

    # Achievements ---------------------------------------
    
    $('.hide-achievements').live 'click', ->
        $('.slider').slideToggle 'slow', () ->
            if $('.achievements').hasClass('hidden')
                $('.achievements').removeClass('hidden')
                $('.hide-achievements').text('hide')
            else
                $('.achievements').addClass('hidden')
                $('.hide-achievements').text('show')

    # SVG ---------------------------------
    $.ajax({
        type: 'GET',
        url: '/svg',
        dataType: 'json',
        success: (results) ->
            for r in results
                $('.badge-select').append('<li badge_id="' + r.id + '">' + r.svg + '</li>')
    })
