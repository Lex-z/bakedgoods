class AddPickuptimeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :pickuptime, :time
  end
end
