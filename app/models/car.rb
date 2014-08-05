# == Schema Information
#
# Table name: cars
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  horse_power :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Car < ActiveRecord::Base
end
