class RenameIngredientsToIngredientsListInRecipes < ActiveRecord::Migration[7.0]
  def change
    rename_column :recipes, :ingredients, :ingredients_list
  end
end
