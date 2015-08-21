class DropBasketFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :basket, :integer, default: 0
  end
end
