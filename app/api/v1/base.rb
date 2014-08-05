module API
  module V1
    class Base < Grape::API
      mount API::V1::Cars
      mount API::V1::Users
      mount API::V1::Auth
      add_swagger_documentation base_path: "/api",
                                api_version: 'v1',
                                hide_documentation_path: true
    end
  end
end