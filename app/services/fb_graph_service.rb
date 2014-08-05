class FbGraphService

# user = OmniauthFacebookService.new(env["omniauth.auth"]).user_from_omniauth
# if user.persisted?

  def initialize(token)
    @token = token
  end

  def request
    graph_url = "https://graph.facebook.com/me?access_token=#{@token}"
    uri = URI.parse(graph_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http_request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(http_request)
    JSON.parse(response.body)
  end

end