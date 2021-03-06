module API
  module V1
    class Users < Grape::API
      # version 'v1' # path-based versioning by default
      # format :json
      include API::V1::Defaults

      resource :users do
        desc "Return list of users"
        get do
          User.all # obviously you never want to call #all here
        end
        
        params do
          requires :token, type: String, desc: "Access token."
        end
        get :me do
          authenticate!
          @current_user
        end

      end
    end
  end
end