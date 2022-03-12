Rails.application.routes.draw do
  get 'lotteries/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cards
  resources :games
  resources :lotteries
end
