class SvgController < ApplicationController
    skip_before_filter :authenticate

    after_filter :set_content_type

    def set_content_type
        headers['Content-Type'] = 'image/svg+xml'
    end

    def show
        badge_name = params[:id]
        badge_color = params[:color]
        
        svg = Rails.application.assets['badges/' + badge_name + '.svg'].to_s
        
        if badge_color
            svg = svg.gsub('</svg>', '<style> * { fill: #' + badge_color + '; }; </style> </svg>')

        end

        # Using regex to replace the width and height
        svg = svg.sub(/width="[0-9.]+px"/, 'width="53px"')
        svg = svg.sub(/height="[0-9.]+px"/, 'height="53px"')
        
        render :inline => svg
    end

end
