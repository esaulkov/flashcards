class AddBasketToCards < ActiveRecord::Migration
  def change
    add_column :cards, :basket, :integer, default: 0
  end
end
