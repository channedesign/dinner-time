namespace :import do
    desc "Import recipes from JSON file"
    task recipes: :environment do
      json_file_path = Rails.root.join('db', 'recipes-en.json')
      recipes_data = JSON.parse(File.read(json_file_path))
  
      recipes_data.each do |recipe_data|
        Recipe.create!(
          title: recipe_data['title'],
          cook_time: recipe_data['cook_time'],
          prep_time: recipe_data['prep_time'],
          ingredients_list: recipe_data['ingredients'].join("\n"),
          ratings: recipe_data['ratings'],
          cuisine: recipe_data['cuisine'],
          category: recipe_data['category'],
          author: recipe_data['author'],
          image: recipe_data['image']
        )
      end
    end
  end