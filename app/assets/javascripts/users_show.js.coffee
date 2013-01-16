
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
                console.log r
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
