class Recipe < ApplicationRecord
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients

    attr_accessor :is_exact

    def is_exact
        @is_exact || false
    end
end
