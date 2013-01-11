
$ ->

    # Badge stuff
    # badge = $('.badge-preview')
    # badgeLogo = badge.find('img')
    # badgeOpened = false

    # $('.badge-select li').live 'click', () ->
    #     $('.badge-select .selected').removeClass('selected')
    #     $(this).addClass('selected')

    #     id = '/svg/' + $(this).attr('badge_id') + '.svg'
    #     color = $('#goal_badge').attr('badge_color')
    #     url = id + '?color=' + color

    #     badgeLogo.attr('src', url)
    #     $('#goal_badge').val(url)
    #     $('#goal_badge').attr('badge_id', id)

    # $('.badge-select').live 'click', (e) ->
    #     e.stopPropagation()


    # Achievements ---------------------------------------
    
    $('.hide-achievements').live 'click', ->
        $('.slider').slideToggle 'slow', () ->
            if $('.achievements').hasClass('hidden')
                $('.achievements').removeClass('hidden')
                $('.hide-achievements').text('hide')
            else
                $('.achievements').addClass('hidden')
                $('.hide-achievements').text('show')


    # Event details form ---------------------------------

    # eventDetails = $('.event-details')
    # eventExtended = false

    # $('.new_event').submit () ->

    #     article = $(this).parent()
        
        
    #     ididit = article.find('input[type=submit]').val()
    #     eventDetails.find('input[type=button]').val(ididit)

    #     eventDetails.hide()
    #     eventDetails.css('top', $(this).offset().top - 51)

    #     # Offset for subgoals
    #     if article.parent().hasClass('sub')
    #         eventDetails.css('left', '165px')
    #     else
    #         eventDetails.css('left', '142px')
            

    #     # Putting in the correct goal_id
    #     eventDetails.find('#event_goal_id').val(article.find('#event_goal_id').val())

    #     # if not eventExtended
    #     eventDetails.animate({
    #         width: 'toggle'
    #         height: 'toggle'
    #         # opacity: 'toggle'
    #         display: 'block'
    #     }, 300, 'linear', ->
    #         eventDetails.find('textarea').focus()
    #         eventExtended = true
    #     )

    #     # Changing the number on evented
    #     evented = article.parent().find('.evented')
        
    #     evented.text(parseInt(evented.text()) + 1)
    #     evented.show()


    # $('.close').live 'click', ->

    #     # Check if form is filled in. Warning?
    #     if eventExtended
    #         eventDetails.animate({
    #             width: 'toggle'
    #             height: 'toggle'
    #             # opacity: 'toggle'
    #             display: 'none'
    #         }, 300, 'linear', ->
    #             eventExtended = false
    #         )

    #     # easeOutElastic

    # # Intercept click event
    # eventDetails.live 'click', (e) ->
    #     e.stopPropagation()    

    # SVG ---------------------------------
    $.ajax({
        type: 'GET',
        url: '/svg',
        dataType: 'json',
        success: (results) ->
            for r in results
                $('.badge-select').append('<li badge_id="' + r.id + '">' + r.svg + '</li>')
    })

    # Alternate SVG color loading (without replacing src) 
    # <script>
    # //<![CDATA[
            
    #     // wait until all the resources are loaded
    #     window.addEventListener("load", findSVGElements, false);
        
    #     // fetches the document for the given embedding_element
    #     function getSubDocument(embedding_element)
    #     {
    #         if (embedding_element.contentDocument) 
    #         {
    #             return embedding_element.contentDocument;
    #         } 
    #         else 
    #         {
    #             var subdoc = null;
    #             try {
    #                 subdoc = embedding_element.getSVGDocument();
    #             } catch(e) {}
    #             return subdoc;
    #         }
    #     }
                
    #     function findSVGElements()
    #     {
    #         var elms = document.querySelectorAll("embed");
    #         for (var i = 0; i < elms.length; i++)
    #         {
    #             var subdoc = getSubDocument(elms[i])
    #             if (subdoc)
    #                 subdoc.getElementById("svgbar").setAttribute("fill", "lime");
    #         }
    #     }
    #     //]]>
    # </script>
