Rails.application.routes.draw do
  resources :adverts
  get '/users/create_admin'
  devise_for :users
  post '/properties/img_post' => 'properties#img_post'
  post '/properties/img_rm' => 'properties#img_rm'
  get 'pages/more_filters'
  get 'pages/landing'
  get 'pages/browse'
  get 'pages/untitled'
  get 'pages/listing_details/:listing_id' => 'pages#listing_details'
  get 'pages/search'
  get 'pages/offer_1'
  get 'pages/offer_2'
  get 'pages/offer_3'
  get 'pages/offer_4'
  get 'pages/offer_5'
  get 'pages/offer_6'
  put '/pages/best_in_place_update'
  put '/pages/offer_5' => 'pages#put_todo'
  get '/pages/user_dashboard'
  get '/pages/admin_dashboard'
  post 'api/favorite_on'
  post 'api/favorite_off'
  root 'pages#landing'
  resources :users do
    resources :adverts
  end
  resources :properties

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
