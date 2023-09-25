json.extract! recipe, :id, :title, :cook_time, :prep_time, :ingredients, :ratings, :cuisine, :category, :author, :image, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
