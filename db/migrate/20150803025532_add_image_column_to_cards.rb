class AddImageColumnToCards < ActiveRecord::Migration
  def up
    add_attachment :cards, :image
  end

  def down
    remove_attachment :cards, :image
  end
end
