class SearchController < ApplicationController
  def index
  end

  def results
    ingredients = params[:ingredients].split(',').map { |ingredient| ingredient.gsub(/\([^)]*\)|[^a-zA-Z\s]/, "").strip.downcase }
   
    @recipes = Recipe.joins(:ingredients)
                    .where("ingredients.name LIKE ANY (array[?])", ingredients.map { |ingr| "%#{ingr}%" })
                    .group('recipes.id')
                    .having('COUNT(DISTINCT ingredients.name) = ?', ingredients.length)
    

    @exact_recipes = @recipes.select { |recipe| recipe.ingredients.count == ingredients.length }
    @exact_recipes.each { |recipe| recipe.is_exact = true }
    
    @extra_recipes = @recipes.reject { |recipe| @exact_recipes.include?(recipe) || (recipe.ingredients.count - ingredients.length).abs > 3 }

    respond_to do |format|
      format.json
    end
  end
end
