Rails.application.routes.draw do
  devise_for :users
  root to: "illustrations#index"

  resources :illustrations, only: %i[index show create]
end
