class ChangeTimeColumns < ActiveRecord::Migration
  def change
    change_column :foods, :pickuptime_start, :datetime
    change_column :foods, :pickuptime_end, :datetime
    change_column :orders, :pickuptime, :datetime
  end
end
