Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'query/' => 'query#index', as: :query

  mount Facebook::Messenger::Server, at:"bot"
end
