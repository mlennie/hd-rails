Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  ActiveAdmin.routes(self)
  root 'admin/dashboard#index'

  resources :users, only: :create
end
