json.array! @recipes do |recipe|
    json.id recipe.id
    json.title recipe.title
    json.cook_time recipe.cook_time
    json.prep_time recipe.prep_time
    json.ingredients_list recipe.ingredients_list
    json.ratings recipe.ratings
    json.cuisine recipe.cuisine
    json.category recipe.category
    json.author recipe.author
    json.image recipe.image
    json.created_at recipe.created_at
    json.updated_at recipe.updated_at
end