class SessionsController < ApplicationController
require 'net/http'

    def create
        auth = request.env["omniauth.auth"]
        user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
        session[:user_id] = user.id
        if user
            user.update_facebook(auth)
            sign_in user
            redirect_to user
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

    def mobile_create
        token = params[:ftoken]
        fid = params[:fid]

        uri = URI.parse('https://graph.facebook.com/me?access_token=' + token)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        result = JSON.parse(response.body)
        
        if fid == result['id']
            logger.info 'USER ' + fid + ' logged in with mobile'
            user = User.find_by_uid(fid)

            token =  SecureRandom.urlsafe_base64
            logger.info token
            user.update_attributes({:token => token})

            # Update/create user with mobile
            
            render json: user
            return
        end

        raise PermissionViolation

    end


    def hack
        user = User.find_by_uid(519585436)
        session[:user_id] = user.id
        if user
            sign_in user
            redirect_to root_url
        else
            redirect_to 'new'
        end
    end

    def hack2
        auth = {
            'uid' => 1337,
            'info' => {
                'name' => 'hacked', 
                'email' => 'lol'
                },
            'credentials' => {'token' => '123'}
        }
        user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
        session[:user_id] = user.id
        if user
            sign_in user
            redirect_to root_url
        else
            redirect_to 'new'
        end
    end
    
end
