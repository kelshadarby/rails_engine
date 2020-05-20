Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new, :edit]
      resources :merchants, except: [:new, :edit]
      get '/items/:id/merchant', to: 'merchant_items#show'
      get '/merchants/:id/items', to: 'merchant_items#index'
    end
  end
end
