Rails.application.routes.draw do
  root 'search#index'
  get 'search/results'
  resources :recipe_ingredients
  resources :ingredients
  resources :recipes
end
