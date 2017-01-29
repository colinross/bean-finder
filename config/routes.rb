Rails.application.routes.draw do
  resources :locations, only: [:index] do
    post :upload, on: :collection
  end

  root 'locations#index'
end
