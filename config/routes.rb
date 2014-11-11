Rails.application.routes.draw do

  get 'password_resets/new'

  resources :invitations

  resources :votes

  resources :restaurants

  resources :password_resets

  #get '/' => 'meetings#index'
  #root 'sessions#new'
  root 'sessions#frontpage'

  resources :meetings 
  get 'meetings/:id/select_members' => 'meetings#select_members', as: :select_members
  post 'meetings/:id/submit_members' => 'meetings#submit_members'
  get 'meetings/:id/select_restaurants' => 'meetings#select_restaurants', as: :select_restaurants
  get 'meetings/:id/add_restaurants_by_address' => 'meetings#add_restaurants_by_address', as: :add_restaurants_by_address
  get 'meetings/:id/add_restaurants_by_location' => 'meetings#add_restaurants_by_location', as: :add_restaurants_by_location
  post 'meetings/:id/submit_restaurants' => 'meetings#submit_restaurants'
  get 'meetings/:id/update_vote' => 'meetings#update_vote', as: :update_vote
  get 'meetings/:id/set_decision' => 'meetings#set_decision', as: :set_decision
  get 'meetings/:id/get_default_restaurants' => 'meetings#get_default_restaurants', as: :get_default_restaurants
  get 'meetings/:id/search_restaurants' =>'meetings#search_restaurants', as: :search_restaurants
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  match '/signup', to: 'users#new', via: 'get'
  match '/signup/:invitation_token', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to:'sessions#destroy', via: 'delete'

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
