class CreateFtIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ft_ingredients do |t|
      t.string :label
      t.string :text

      t.timestamps
    end
  end
end
