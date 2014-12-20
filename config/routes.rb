Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: { sessions: 'sessions' }
  ActiveAdmin.routes(self)
  root 'admin/dashboard#index'

  resources :users, only: [:create, :show]
  resources :contact_emails, only: [:create]
  resources :pre_subscribers, only: [:create]

  get 'confirm', to: 'users#confirm', as: 'confirm'
end
