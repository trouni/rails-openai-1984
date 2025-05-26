Rails.application.routes.draw do
  root to: "pages#home"

  resources :characters, only: %i[show create] do
    resources :illustrations, only: %w[index]
  end
  resources :illustrations, only: :destroy
end
