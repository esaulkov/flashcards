require_relative "20150811042117_add_basket_to_cards"

class AddEfactorToCards < ActiveRecord::Migration
  def change
    revert AddBasketToCards

    add_column :cards, :e_factor, :float, default: 2.5
    add_column :cards, :repetition, :integer, default: 1
  end
end
