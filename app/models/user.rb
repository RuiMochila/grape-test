# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  age             :integer
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
	has_many :api_key

	# attr_accessible :email, :name, :password, :password_confirmation, 
 #    	:description, :presentation_picture, :remote_presentation_picture_url,
 #    	:postal_code, :address, :location, :city, :country, :phone, 
 #    	:facebook_url, :twitter_url, :website_url,
 #    	:age, :sex, :status

  has_many :authentications, dependent: :destroy

  validates :email, presence: true,
            length: { maximum: 75 },
            :uniqueness => { :case_sensitive => false },
            format: { :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i,
                      :message => 'This email address it not valid.'}
  
  URL_REGEX = /\b((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/?)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s\`!()\[\]{};:\'\".,<>?«»“”‘’]))/i
  
  validates :name, presence: true, length: { maximum: 70 }
  
  has_secure_password
  #validates :password, presence: true, length: { minimum: 6 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save { email.downcase! }
  
  def self.create_with_auth_data(auth)
    # case auth['provider']
    # when 'facebook'
    	pass = rand(36**10).to_s(36)
      # birthday = DateTime.strptime(auth['extra']['raw_info']['birthday'], '%m/%d/%Y')
      # now = Time.now.utc.to_date
      # age = now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
    	create(name: auth['name'], email: auth['email'], 
        	# facebook_url: auth['info']['urls']['Facebook'], location: auth['info']['location'], 
        	# sex: auth['extra']['raw_info']['gender'], age: age,
        	password: pass, password_confirmation: pass)
    # when 'identity'
    # 	#This will start to be used
    # else
    #   # Some other provider I didn't implemented yet.
    # 	'default'
    # end
  end

  def link(provider)
    link = nil
    self.authentications.each do |authentication|
      if authentication.provider == provider
        link = authentication
      end
    end
    link
  end

end
