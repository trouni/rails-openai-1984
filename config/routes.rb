Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :characters do
    resources :illustrations, only: :create
  end
  resources :illustrations, only: :show
end
