class SearchController < ApplicationController
  def index
  end

  def results
    ingredients = params[:ingredients].split(',').map { |ingredient| ingredient.strip.downcase }

    @recipes = Recipe.joins(:ingredients)
                    .where("ingredients.name LIKE ANY (array[?])", ingredients.map { |ingr| "%#{ingr.downcase}%" })
                    .group('recipes.id')
                    .having('COUNT(DISTINCT ingredients.name) = ?', ingredients.length)
    
    @recipes = @recipes.map { |recipe| recipe.ingredients.count == ingredients.count ? recipe : nil}.compact

    puts "=============="
    puts "Input ingredients count: #{ingredients.count}"
    puts "Input ingredients: #{ingredients}"
    puts @recipes.count
    puts "=============="

    # render :results
    respond_to do |format|
      format.json
    end
  end
end
