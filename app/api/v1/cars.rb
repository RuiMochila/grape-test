module API
  module V1
    class Cars < Grape::API
      # version 'v1' # path-based versioning by default
      # format :json
      include API::V1::Defaults
      # include Roar::Rails

      resource :cars do
        desc 'Get paginated cars'
        # Annotate action with `paginate`.
        # This will add two optional params: page and per_page
        # You can optionally overwrite the default :per_page setting (10)
        params do
          requires :token, type: String, desc: "Access token."
        end
        paginate
        get do
          authenticate!
          cars = Car.all # obviously you never want to call #all here
          # cars = Car.where(...)
          paginate(cars)
          # represent_each paginate(cars), with: CarRepresenter
        end
      end
    end
  end
end