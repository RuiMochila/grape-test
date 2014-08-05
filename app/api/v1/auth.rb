module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      resource :auth do

        desc "Creates and returns access_token if valid login"
        params do
          requires :login, type: String, desc: "Username or email address"
          requires :password, type: String, desc: "Password"
        end
        post :login do
          
          # if params[:login].include?("@")
          user = User.find_by_email(params[:login].downcase)
          # else
          #   user = User.find_by_login(params[:login].downcase)
          # end
          # user = FacebookLoginService.new(env["omniauth.auth"]).user_from_omniauth

          # if user.persisted?
          if user && user.authenticate(params[:password])
            key = ApiKey.create(user_id: user.id)
            {token: key.access_token, user: user}
          else
            error!('Unauthorized.', 401)
          end

        end

        desc "Facebook login/register and returns user and token"
        params do
          requires :token, type: String, desc: "Facebook auth token"
        end
        post :facebook_login do
          
          #Authentication connection logic
          token = params[:token]
          graph_url = "https://graph.facebook.com/me?access_token=#{token}"
          uri = URI.parse(graph_url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http_request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(http_request)
          auth_data = JSON.parse(response.body)

          if !auth_data['error'].nil?
            error!('Unauthorized.', 401)
          end

          auth = Authentication.find_with_auth_data(auth_data)
          
          already_existed = false    
          if auth.nil?
            auth = Authentication.create_with_auth_data(auth_data)
          else
            already_existed = true
          end

          if !auth.user.nil?
            # Auth has a user, so lets sign him in.
            key = ApiKey.create(user_id: auth.user.id)
            {token: key.access_token, user: auth.user}
          else
            # Auth doesn't have user.
            #identity faz outra coisa...?

            # If its not, then create a new user with omniauth.
            # Unless it already existed an authentication with the same email (plain email registry or g+ registry) as this one, so load that user.
            #I don't have here the possibility for the user to be logged in to connect different authentications with different emails but still need to deal with this case.
            @other_auth = Authentication.find_by_email(auth.email)
            if @other_auth && already_existed
              user = @other_auth.user
            else
              user = User.create_with_auth_data(auth_data)
            end

            # Add the authentication to the created or loaded user.
            user.authentications << auth
            key = ApiKey.create(user_id: user.id)
            {token: key.access_token, user: user}
          end
        end

        desc "Returns pong if logged in correctly"
        params do
          requires :token, type: String, desc: "Access token."
        end
        get :ping do
          authenticate!
          { message: "pong" }
        end

      end
    end
  end
end