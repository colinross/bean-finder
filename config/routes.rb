Rails.application.routes.draw do
  resources :locations, only: [:index] do
  end

  root 'locations#index'
end
