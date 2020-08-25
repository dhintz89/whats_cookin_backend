class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
        JWT.encode(payload, ENV["JWT_Secret"])
    end

    def auth_header
        request.headers['Authorization']
    end
    
    def decoded_token
        binding.pry
        if auth_header
            token = auth_header.split(' ')[1]
            puts "decoded_token function: token: #{token}"
            begin
                return JWT.decode(token, ENV["JWT_Secret"])
                puts "decoded_token function: decoded_token: #{JWT.decode(token, ENV["JWT_Secret"])}"
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def current_user
        puts "current_user function 1"
        puts "#{decoded_token}"
        puts "decoded_token if: #{!!decoded_token}"
        if decoded_token
            puts "current_user function 2"
            user_id = decoded_token[0]['user_id']
            puts "current_user function: user_id: #{user_id}; "
            @user = User.find_by(id: user_id)
            puts "current_user function: @user: #{@user}"
        end
    end

    def logged_in?
        !!current_user
        puts "logged_in?: #{!!current_user}"
    end

    def authorized
        puts "authorized function: is someone logged in: #{logged_in?}"
        render json: {error: 'You must log in to perform that action'}, status: :unauthorized unless logged_in?
    end

end
