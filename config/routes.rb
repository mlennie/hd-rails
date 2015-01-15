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

  get 'resend_confirmation', to: 'users#resend_confirmation', 
                             as: 'resend_confirmation'
  get 'confirm', to: 'users#confirm', as: 'confirm'
  get 'password_email', to: 'users#password_email', as: 'password_email'
  get 'edit_password', to: 'users#edit_password', as: 'edit_password'
  post 'update_password', to: 'users#update_password', as: 'update_password'
end
