module API
  module V2
    class Cars < Grape::API
      version 'v2' # path-based versioning by default
      format :json

      resource :cars do
        desc "Return list of cars"
        get do
          Car.all # obviously you never want to call #all here
        end
      end
    end
  end
end