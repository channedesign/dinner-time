namespace :populate do
    desc "Populate ingredients table and associate with recipes"
    task ingredients: :environment do
      RecipeIngredient.delete_all
      Ingredient.delete_all 
  
      recipes = Recipe.all
      ingredient_parser = IngredientParser::Parser.new
    
      recipes.each do |recipe|
        ingredients = recipe.ingredients_list.split("\n")
        ingredients.each do |ingredient|
          
          puts ingredient
          begin
            # Parse the ingredient
            parsed_ingredient = ingredient_parser.parse(ingredient.gsub(/(\d+\/\d+|\d+|½|⅓|¼|⅕|⅙|⅐|⅛|⅑|⅒|¾|⅔|%)\s*|\([^)]*\)|\b[A-Z]+\b|\w+®|®|'|-inch|(^|[^a-zA-Z])[-*]|[-*](?=[^a-zA-Z]|$)|\b(?:a|the|to|fresh)\b/, '').split(",").first.strip.downcase.squish)

            # Extract the ingredient name from parsed_ingredient
            ingredient_name = parsed_ingredient[:name]
          rescue
            ingredient_name = ingredient
          end
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