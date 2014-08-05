# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  token      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :email
  belongs_to :user
  
  def self.find_with_auth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end
 
  def self.create_with_auth(auth)
  	case auth['provider']
    when 'facebook'
    	create(uid: auth['uid'], provider: auth['provider'], email: auth['info']['email'])
    when 'google_oauth2'
    	create(uid: auth['uid'], provider: auth['provider'], email: auth['info']['email'])
    else
    	create(uid: auth['uid'], provider: auth['provider'])
    end
     # and other data you might want from the auth hash
  end

  def self.create_with_fb_graph_response(auth)
    create(uid: auth['id'], provider: 'facebook', email: auth['email'])
  end
end
