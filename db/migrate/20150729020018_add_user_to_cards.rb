class AddUserToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :user
  end
end
