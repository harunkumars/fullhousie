Rails.application.routes.draw do
  get 'lotteries/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cards, only: [:show]
  resources :games, only: [:show, :update]
  resources :lotteries, only: [:update]
end
