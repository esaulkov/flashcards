class AddEfactorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :e_factor, :float, default: 2.5
    add_column :cards, :repetition, :integer, default: 1
  end
end
