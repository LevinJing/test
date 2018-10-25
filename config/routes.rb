Rails.application.routes.draw do
  resources :meeting_configs, only: [:index, :create, :update]
end
