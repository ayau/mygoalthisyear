class SvgController < ApplicationController
    skip_before_filter :authenticate

    after_filter :set_content_type

    def set_content_type
        headers['Content-Type'] = 'image/svg+xml'
    end

    def show
        badge_name = params[:id]
        badge_color = params[:color]
        
        svg = render_svg(badge_name, badge_color)
        
        render :inline => svg
    end

    def index

        badges = Dir.glob("app/assets/images/badges/*")
        
        svgs = []

        badges.each do |badge|
        
            url = badge.sub('app/assets/images/badges/', '').sub('.svg', '')
            
            svgs << {:id => url, :svg => render_svg(url, nil, 40)}      

        end 

        respond_to do |format|
            format.json { render json: svgs }
        end

    end

    def api
        badge_name = params[:id]
        badge_color = params[:color]
        
        svg = render_svg_api(badge_name, badge_color)
        
        render :inline => svg
    end

    private

    def render_svg (name, color, size = 53)

        svg = Rails.application.assets['badges/' + name + '.svg'].to_s
        
        if color
            svg = svg.gsub('</svg>', '<style> * { fill: #' + color + '; }; </style> </svg>')
        end

        # Using regex to replace the width and height
        svg = svg.sub(/width="[0-9.]+px"/, 'width="' + size.to_s + 'px"')
        svg = svg.sub(/height="[0-9.]+px"/, 'height="' + size.to_s + 'px"')

        return svg
    end

    def render_svg_api (name, color)

        svg = Rails.application.assets['badges/' + name + '.svg'].to_s
        
        # # Using regex to replace the width and height
        viewbox = /viewBox="([0-9.]+) ([0-9.]+) ([0-9.]+) ([0-9.]+)"/.match(svg)
        
        x = viewbox[1].to_i
        y = viewbox[2].to_i
        x1 = viewbox[3].to_i
        y1 = viewbox[4].to_i
        
        svg = svg.sub(/width="[0-9.]+px"/, 'width="' + (x1 + x).to_s + 'px"')
        svg = svg.sub(/height="[0-9.]+px"/, 'height="' + (y1 + y).to_s + 'px"')
        
        return svg
    end


end
