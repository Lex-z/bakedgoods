class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :food
      t.text :description
      t.integer :user_id
      t.integer :servings_avail
      t.integer :servings_purch
      t.string :image
      t.time :pickuptime_start
      t.time :pickuptime_end
      t.integer :taste_rate
      t.integer :portion_rate
      t.integer :value_rate

      t.timestamps

    end
  end
end
