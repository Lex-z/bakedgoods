class AddPriceNotetoFoodOrder < ActiveRecord::Migration
  def change
  add_column :foods, :price, :decimal
  add_column :orders, :note, :text
  end
end
