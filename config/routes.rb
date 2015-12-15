Rails.application.routes.draw do
  # root to: 'visitors#index'
  root to: 'tasks#index'
  devise_for :users
  resources :users
  resources :tasks, shallow: true do
    post 'change_state'
  end
end
