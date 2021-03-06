Bucketlist::Application.routes.draw do

    root to: 'pages#home'
    
    match "/auth/:provider/callback" => "sessions#create" 
    match "/signout" => "sessions#destroy", :as => :signout

    # mobile login
    match "/api/login" => "sessions#mobile_create"

    match '/donthackmebro' => 'sessions#hack'
    match '/donthackmebro2' => 'sessions#hack2'

    resources :sessions, only: [:new, :create, :destroy]

    resources :goals do
        member do
            put 'complete'
            put 'make_incomplete'
            post 'subgoals'
            get 'choose_subgoal'
            post 'set_subgoal'
            put 'invite'
            put 'accept_invite'
            put 'decline_invite'
        end
    end

    resources :users do
        member do
            get 'timeline'
            put 'add_goal'
            put 'remove_goal'
            get 'achievements'
        end

        collection do
            get 'search'
        end
    end

    resources :events do
        collection do
            post 'add_details'
        end
    end

    resources :svg, :only => [:show, :index]

    scope '/api', :defaults => { :format => 'json' } do
        get 'me' => 'users#me'
        resources :users, only: [:goals] do
            member do
                get 'goals/current' => 'users#current_goals'
                get 'goals/bucket' => 'users#bucket_goals'
                get 'goals/achieved' => 'users#achieved_goals'
                get 'goals/sync' => 'users#sync' # for mobile sync
            end
        end

        match  '/svg/:id' => 'svg#api'
    end

    # The priority is based upon order of creation:
    # first created -> highest priority.

    # Sample of regular route:
    #   match 'products/:id' => 'catalog#view'
    # Keep in mind you can assign values other than :controller and :action

    # Sample of named route:
    #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
    # This route can be invoked with purchase_url(:id => product.id)

    # Sample resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Sample resource route with options:
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

    # Sample resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Sample resource route with more complex sub-resources
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', :on => :collection
    #     end
    #   end

    # Sample resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end

    # You can have the root of your site routed with "root"
    # just remember to delete public/index.html.
    # root :to => 'welcome#index'

    # See how all your routes lay out with "rake routes"

    # This is a legacy wild controller route that's not recommended for RESTful applications.
    # Note: This route will make all actions in every controller accessible via GET requests.
    # match ':controller(/:action(/:id))(.:format)'
end
