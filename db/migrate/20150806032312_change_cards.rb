class ChangeCards < ActiveRecord::Migration
  def change
    remove_reference :cards, :user
    add_reference :cards, :deck
  end
end
