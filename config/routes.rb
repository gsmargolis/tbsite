Rails.application.routes.draw do
  

  get 'import/getdata', to: 'import#getdata'

  resources :weeks, except: [:new, :destroy, :update, :edit, :create]
  
  resources :users, except: [:new]
  
  resources :players, except: [:new, :destroy, :update, :edit, :create]
  
  get '/register', to: 'users#new'
  #get 'pages/home'

  get '/importplayers', to: 'pages#importplayers'
  get '/importgames', to: 'pages#importgames'
  get '/importpicks', to: 'pages#importpicks'
  get '/importawards', to: 'pages#importawards'
  #get '/players', to: 'pages#players'
  get '/summary', to: 'pages#summary'
  get '/updateawards', to: 'pages#updateawards'
  post '/nextwins', to: 'users#nextwins'
  get '/login', to: "logins#new"
  post '/login', to: "logins#create"
  get '/logout', to: "logins#destroy"
  get 'updatecbs', to: "update#updatecbs"
  
  
  get '/updateawards/:id', to: 'pages#updateawards'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
