module API
  class Dispatch < Grape::API
    mount API::V1::Base
    mount API::V2::Base
  end

   Base = Rack::Builder.new do
    use API::Logger
    run API::Dispatch
  end
end