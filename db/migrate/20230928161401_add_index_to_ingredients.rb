class AddIndexToIngredients < ActiveRecord::Migration[7.0]
  def change
    add_index :ingredients, :name
  end
end
