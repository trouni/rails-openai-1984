Rails.application.routes.draw do
  root to: "pages#home"

  resources :characters, only: %i[show create]
  resources :illustrations, only: :destroy
end
