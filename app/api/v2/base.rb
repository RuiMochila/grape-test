module API
  module V2
    class Base < Grape::API
      mount API::V2::Cars
      mount API::V2::Users
    end
  end
end