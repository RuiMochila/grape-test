# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  age        :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	has_many :api_key
end
