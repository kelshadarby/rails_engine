Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new, :edit]
      resources :merchants, except: [:new, :edit]
      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
      end
      namespace :merchants do
        get '/:id/items', to: 'items#index'
      end
    end
  end
end
