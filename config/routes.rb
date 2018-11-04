Rails.application.routes.draw do
  resources :meeting_messages
  resources :meeting_configs, only: [:index, :create, :update]
end
