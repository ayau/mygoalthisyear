module SvgHelper

    def generate_color (c)

        color = "%06x" % (rand * 0xffffff)

        while color_distance(c, color) < 180
            color = "%06x" % (rand * 0xffffff)
        end

        return color
        # logger.info color_distance(badge_color, bg)
    end
    
    private

    def color_distance(c0, c1)
        rgb0 = hex_to_rgb(c0)
        rgb1 = hex_to_rgb(c1)

        luv0 = rgb_to_luv(rgb0)
        luv1 = rgb_to_luv(rgb1)

        return Math.sqrt((luv0['l'] - luv1['l']) ** 2 + (luv0['u'] - luv1['u']) ** 2 + (luv0['v'] - luv1['v']) ** 2)

    end 

    def hex_to_rgb (h)
        m = /(..)(..)(..)/.match(h)
        return {
            'r' => m[1].hex,
            'g' => m[2].hex,
            'b' => m[3].hex
        }
    end

    def rgb_to_luv (rgb)
        xyz = rgb_to_xyz(rgb)
        return xyz_to_luv(xyz)
    end

    def xyz_to_luv (xyz)
        x = xyz['x']
        y = xyz['y']
        z = xyz['z']

        var_U = ( 4 * x ) / ( x + ( 15 * y ) + ( 3 * z ) )
        var_V = ( 9 * y ) / ( x + ( 15 * y ) + ( 3 * z ) )

        var_Y = y / 100

        if var_Y > 0.008856 
            var_Y = var_Y ** ( 1/3 )
        else
            var_Y = 7.787 * var_Y  +  16 / 116 
        end

        ref_x =  95.047        #Observer= 2°, Illuminant= D65
        ref_y = 100.000
        ref_z = 108.883

        ref_U = ( 4 * ref_x ) / ( ref_x + ( 15 * ref_y ) + ( 3 * ref_z ) )
        ref_V = ( 9 * ref_y ) / ( ref_x + ( 15 * ref_y ) + ( 3 * ref_z ) )

        l = ( 116 * var_Y ) - 16
        
        return {
            'l' => l,
            'u' => 13 * l * ( var_U - ref_U ),
            'v' => 13 * l * ( var_V - ref_V )
        }
    end

    def rgb_to_xyz (rgb)
        var_R = ( rgb['r'].to_f / 255 )        # R from 0 to 255
        var_G = ( rgb['g'].to_f / 255 )        # G from 0 to 255
        var_B = ( rgb['b'].to_f / 255 )        # B from 0 to 255
        
        if var_R > 0.04045 
            var_R = ( ( var_R + 0.055 ) / 1.055 ) ** 2.4
        else                   
            var_R = var_R / 12.92
        end

        if var_G > 0.04045 
            var_G = ( ( var_G + 0.055 ) / 1.055 ) ** 2.4
        else                   
            var_G = var_G / 12.92
        end

        if var_B > 0.04045 
            var_B = ( ( var_B + 0.055 ) / 1.055 ) ** 2.4
        else                   
            var_B = var_B / 12.92
        end

        var_R = var_R * 100
        var_G = var_G * 100
        var_B = var_B * 100

        # Observer. = 2°, Illuminant = D65
        return {
            'x' => var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805,
            'y' => var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722,
            'z' => var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505
        }
    end

end
