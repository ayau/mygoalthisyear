class SessionsController < ApplicationController

    def create
        auth = request.env["omniauth.auth"]
        user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
        session[:user_id] = user.id
        if user
            sign_in user
            redirect_to root_url
        else
            redirect_to 'new'
        end
    end

    def new
    end

    def destroy
        session[:user_id] = nil
        sign_out
        redirect_to root_url
    end
    
end
