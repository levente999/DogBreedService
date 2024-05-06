Rails.application.routes.draw do
  root 'breeds#index'
  resources :breeds, only: [:index, :show]
  get 'up' => 'rails/health#show', as: :rails_health_check
  post '/fetch_breed', to: 'breeds#fetch_breed'
end