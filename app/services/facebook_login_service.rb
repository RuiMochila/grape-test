class FacebookLoginService

# user = OmniauthFacebookService.new(env["omniauth.auth"]).user_from_omniauth
# if user.persisted?

  def initialize(auth)
    @auth = auth
  end

  def user_from_omniauth
    authorization = Authentication.where(auth_params).first_or_initialize

    if authorization.user.blank?
      @user = User.where(email: @auth["info"]["email"]).first
      if @user.blank?
        create_user
      end
      authorization.user = @user
      authorization.save!
    end
    authorization.user
  end

  private

  def auth_params
    {
      provider: @auth.provider,
      uid: @auth.uid.to_s,
      token: @auth.credentials.token,
      secret: @auth.credentials.secret,
      username: @auth.info.nickname
    }
  end

  def create_user
    @user = User.new.tap do |u|
      u.name = @auth.info.name
      u.email = @auth.info.email
      u.avatar_url = @auth.info.image
      u.gender = @auth.extra.raw_info.gender
      u.location = @auth.info.location
      u.birthday = Date.strptime(@auth.extra.raw_info.birthday, '%m/%d/%Y')

      u.password = Devise.friendly_token[0,20]
    end
    @user.save!
  end

end