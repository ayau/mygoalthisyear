class ApplicationController < ActionController::Base

    require 'has_restful_permissions'

    protect_from_forgery
    include SessionsHelper

    # before_filter :authenticate

    # def authenticate
    #     if(current_user.nil?)
            # redirect_to root_path 

    #         if(request.env['PATH_INFO'] != loggedout_path && request.env['PATH_INFO'].index('/auth/facebook') != 0 && request.env['PATH_INFO'] != donthackmebro_path)
            # if(request.env['PATH_INFO'] != root_path && request.env['PATH_INFO'].index('/auth/facebook') != 0 && request.env['PATH_INFO'] != donthackmebro_path)
            #     redirect_to(root_path)
            # end
    #       else
    #            redirect_to('/401.html')
    #       end
    #     end
    #     end
    # end

    rescue_from PermissionViolation do |exception|
        render 'pages/permission_denied'
    end

    helper_method :current_user

    private

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
