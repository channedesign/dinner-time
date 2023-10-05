Rails.application.routes.draw do
  root 'search#index'
  get 'search/results'

  resources :recipe_ingredients
  resources :ingredients
  resources :recipes

  get "train_ingredients", to: "ft_ingredients#train", as: "train_ingredients"
  get "predict_ingredients", to: "ft_ingredients#predict", as: "predict_ingredients"
  get "search_labels", to: "ft_ingredients#search_labels", as: "search_labels"
  get "predict_and_fix", to: "ft_ingredients#predict_and_fix", as: "predict_and_fix"
  resources :ft_ingredients
end
