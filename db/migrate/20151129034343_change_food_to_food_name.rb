class ChangeFoodToFoodName < ActiveRecord::Migration
  def change
    add_column :foods, :foodname, :string
    remove_column :foods, :food
  end
end
