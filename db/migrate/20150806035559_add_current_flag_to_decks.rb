class AddCurrentFlagToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :current, :boolean, nil: false, default: false
  end
end
