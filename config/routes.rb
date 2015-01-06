Rails.application.routes.draw do
  mount Documentation::Engine => "/docs"
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: { sessions: 'sessions' }
  ActiveAdmin.routes(self)
  root 'admin/dashboard#index'

  resources :users, only: [:create, :show, :update]
  resources :contact_emails, only: [:create]
  resources :pre_subscribers, only: [:create]
  resources :restaurants, only: [:index]

  get 'confirm', to: 'users#confirm', as: 'confirm'
end
