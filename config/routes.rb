Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'lotteries/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cards, only: [:show]
  resources :lotteries, only: [:update]
  root 'admin/dashboard#index'
end
