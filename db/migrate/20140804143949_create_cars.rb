class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :name
      t.integer :horse_power

      t.timestamps
    end
  end
end
