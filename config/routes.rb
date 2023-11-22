Rails.application.routes.draw do
  root to: "pages#home"

  resources :illustrations, only: %i[index show create]
end
