namespace :populate do
    desc "Populate ft_ingredients table"
    task ft_ingredients: :environment do
        FtIngredient.delete_all
  
      recipes = Recipe.all.limit(200)
      ingredient_parser = IngredientParser::Parser.new
      pattern = /\([^)]*\)|[^a-zA-Z\s]|inch|\b(?:a|the|to|fresh|peeled|unpeeled|thick|chopped|very|sliced|diced|mashed|frozen|for|frying|fried|prepared|refrigerated|shredded|minced|package|finely|seeded|and|cored|cubed|cooked|fully|deveined|small|large)\b/
  
      recipes.each do |recipe|
        ingredients = recipe.ingredients_list.split("\n")
        ingredients.each do |ingredient|
          
          begin
            parsed_ingredient = ingredient_parser.parse(ingredient.split(",").first.gsub(pattern, "").downcase.squish.pluralize)
          rescue
            parsed_ingredient = ingredient_parser.parse(ingredient.gsub(pattern, "").downcase.squish.pluralize)
          end
          # Extract the ingredient name from parsed_ingredient
          ingredient_name = parsed_ingredient[:name]
  
          # Skip if the ingredient name is empty
          next if ingredient_name.blank?
  
          # Check if the Ingredient already exists or create a new one
          ingredient = FtIngredient.create(label: ingredient_name.to_s, text: ingredient)
  
          
        end
      end
    end
  end