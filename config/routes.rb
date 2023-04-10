Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'lotteries/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cards
  resources :games
  resources :lotteries
end
