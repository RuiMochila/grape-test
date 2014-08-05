module API
  module V1
    module Defaults
      # if you're using Grape outside of Rails, you'll have to use Module#included hook
      extend ActiveSupport::Concern
      


      included do
        # common Grape settings
        version 'v1'
        format :json

        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          if Rails.env.development?
            raise e
          else
            # Raven.capture_exception(e)
            error_response(message: "Internal server error", status: 500)
          end
        end

        # HTTP header based authentication
        before do
          #error!('Unauthorized', 401) unless headers['Authorization'] == "some token"
        end

        helpers do
          # def represent(*args)
          #   opts = args.last.is_a?(Hash) ? args.pop : {}
          #   with = opts[:with] || (raise ArgumentError.new(":with option is required"))

          #   raise ArgumentError.new("nil can't be represented") unless args.first

          #   if with.is_a?(Class)
          #     with.new(*args)
          #   elsif args.length > 1
          #     raise ArgumentError.new("Can't represent using module with more than one argument")
          #   else
          #     args.first.extend(with)
          #   end
          # end

          # def represent_each(collection, *args)
          #   collection.map {|item| represent(item, *args) }
          # end

          def authenticate!
            error!('Unauthorized. Invalid or expired token.', 401) unless current_user
          end

          def current_user
            # find token. Check if valid.
            token = ApiKey.where(access_token: params[:token]).first
            if token && !token.expired?
              @current_user = User.find(token.user_id)
            else
              false
            end
          end

          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

        end

      end
    end
  end
end