namespace :populate do
  desc "Populate ingredients table and associate with recipes"
  task ingredients: :environment do
    RecipeIngredient.delete_all
    Ingredient.delete_all 

    recipes = Recipe.all
    ingredient_parser = IngredientParser::Parser.new
    pattern = /\([^)]*\)|[^a-zA-Z\s]|inch|\b(?:a|the|to|fresh|peeled|unpeeled|thick|chopped|very|sliced|diced|mashed|frozen|for|frying|fried|prepared|refrigerated|shredded|minced|package|finely|seeded|and|cored|cubed|cooked|fully|deveined|small|large)\b/

    recipes.each do |recipe|
      ingredients = recipe.ingredients_list.split("\n")
      ingredients.each do |ingredient|
        
        begin
          parsed_ingredient = ingredient_parser.parse(ingredient.split(",").first.gsub(pattern, "").downcase.squish.pluralize)
        rescue
          parsed_ingredient = ingredient_parser.parse(ingredient.gsub(pattern, "").downcase.squish.pluralize)
          puts "================="
          puts "RESCUE"
          puts "This Ingredient: #{ingredient}"
          puts "and now it's ==  #{parsed_ingredient[:name]}  =="
          puts "================="
        end
        # Extract the ingredient name from parsed_ingredient
        ingredient_name = parsed_ingredient[:name]

        # Skip if the ingredient name is empty
        next if ingredient_name.blank?

        # Check if the Ingredient already exists or create a new one
        ingredient = Ingredient.find_or_create_by(name: ingredient_name.to_s)

        # Associate the Ingredient with the Recipe using RecipeIngredient
        RecipeIngredient.find_or_create_by(recipe: recipe, ingredient: ingredient)
      end
    end
  end
end
