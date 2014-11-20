require "resque/server"

G5CMS::Application.routes.draw do
  mount G5Authenticatable::Engine => '/g5_auth'

  # Dashboard for Resque job queues
  mount Resque::Server, :at => "/resque"

  # API endpoints
  namespace :api do
    namespace :v1 do
      get '/sign_upload', to: 'assets#sign_upload'
      get '/sign_delete', to: 'assets#sign_delete'

      resources :clients, only: [:show] do
        post "deploy_websites"
      end

      resources :locations, only: [:index, :show]
      resources :websites, only: [:index, :show] do
        post "deploy"
      end
      resources :website_templates, only: [:show]
      resources :web_layouts, only: [:show, :update]
      resources :web_themes, only: [:show, :update]
      resources :head_widgets, only: [:index, :show, :create, :destroy]
      resources :logo_widgets, only: [:index, :show, :create, :destroy]
      resources :btn_widgets, only: [:index, :show, :create, :destroy]
      resources :nav_widgets, only: [:index, :show, :create, :destroy]
      resources :aside_before_main_widgets, only: [:index, :show, :create, :update, :destroy]
      resources :aside_after_main_widgets, only: [:index, :show, :create, :update, :destroy]
      resources :footer_widgets, only: [:index, :show, :create, :destroy]

      resources :web_home_templates, only: [:index, :show, :update]
      resources :web_page_templates, only: [:index, :show, :create, :update, :destroy]
      resources :main_widgets, only: [:index, :show, :create, :update, :destroy]
      resources :assets, only: [:index, :show, :create, :update, :destroy]

      resources :garden_web_layouts, only: [:index] do
        collection do
          post "update"
        end
      end

      resources :garden_web_themes, only: [:index] do
        collection do
          post "update"
        end
      end

      resources :garden_widgets, only: [:index] do
        collection do
          post "update"
        end
      end

      resources :releases, only: [:index, :show] do
        post "website/:website_slug", to: 'releases#rollback'
      end
      resources :saves, only: [:index, :show, :create] do
        post "restore"
      end
    end
  end

  # TODO: move to API endpoint
  resources :websites, only: [] do
    member do
      post "deploy"
    end
  end

  get "/location_cloner", to: "location_cloner#index"
  post "/location_cloner/clone_location", to: "location_cloner#clone_location"

  # Widget edit modals
  resources :widgets, only: [:edit, :update]

  # WidgetEntry is published for new form widget
  resources :widget_entries, only: [:index, :show]
  resources :tags, only: [:show]
  resources :garden_updates, only: :update

  post "update" => "webhooks#update"

  get "/areas/:state", to: "area_pages#show"
  get "/areas/:state/:city", to: "area_pages#show"
  get "/areas/:state/:city/:neighborhood", to: "area_pages#show"

  # Ember.js application
  get "/:location_slug", to: "locations#index"
  get "/:location_slug/:web_page_template_slug", to: "locations#index"
  get "/:urn/:vertical_slug/:state_slug/:city_slug", to: "web_templates#show"
  get "/:urn/:vertical_slug/:state_slug/:city_slug/:web_template_slug", to: "web_templates#show"
  get "/:vertical_slug/:state_slug/:city_slug/:owner_urn/:web_template_slug", to: "web_templates#show"

  # Root to Ember.js application
  root to: "locations#index"
end
