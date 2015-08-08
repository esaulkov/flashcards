class AddCurrentDeckToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_deck_id, :integer, null: true
  end
end
