class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
    	t.integer  :user_id
	    t.string   :provider
	    t.string   :uid
	    t.string   :token
	    t.string   :email
	    t.timestamps
    end
  	add_index :authentications, :email
  	add_index :authentications, :uid
  	add_index :authentications, :user_id
  end
end
