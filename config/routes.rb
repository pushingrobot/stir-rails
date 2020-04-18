Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    root 'home#index'

    get '/login',     to: 'sessions#new',     as: 'login'
    get '/logout',    to: 'sessions#destroy', as: 'logout'
    post '/sessions', to: 'sessions#create',  as: 'sessions'

    get '/stir/:device_id', to: 'stir#stir', as: 'stir'
    get '/poll/:device_id', to: 'stir#poll', as: 'poll'

    namespace 'admin' do
      get '/lookup', to: 'devices#lookup', as: 'lookup'
      resources :users
    end
  end
end
