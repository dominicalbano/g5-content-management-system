require "resque/server"

G5CMS::Application.routes.draw do
  mount G5Authenticatable::Engine => '/g5_auth'

  # Dashboard for Resque job queues
  mount Resque::Server, :at => "/resque"

  # API endpoints
  namespace :api, defaults: {format: :json} do
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

      match :head_widgets, to: 'head_widgets#options', via: [:options]
      match "head_widgets/:id", to: 'head_widgets#options', via: [:options]
      resources :head_widgets, only: [:index, :show, :create, :destroy]

      match :logo_widgets, to: 'logo_widgets#options', via: [:options]
      match "logo_widgets/:id", to: 'logo_widgets#options', via: [:options]
      resources :logo_widgets, only: [:index, :show, :create, :destroy]

      match :btn_widgets, to: 'btn_widgets#options', via: [:options]
      match "btn_widgets/:id", to: 'btn_widgets#options', via: [:options]
      resources :btn_widgets, only: [:index, :show, :create, :destroy]

      match :nav_widgets, to: 'nav_widgets#options', via: [:options]
      match "nav_widgets/:id", to: 'nav_widgets#options', via: [:options]
      resources :nav_widgets, only: [:index, :show, :create, :destroy]

      match :aside_before_main_widgets, to: 'aside_before_main_widgets#options', via: [:options]
      match "aside_before_main_widgets/:id", to: 'aside_before_main_widgets#options', via: [:options]
      resources :aside_before_main_widgets, only: [:index, :show, :create, :update, :destroy]

      match :aside_after_main_widgets, to: 'aside_after_main_widgets#options', via: [:options]
      match "aside_after_main_widgets/:id", to: 'aside_after_main_widgets#options', via: [:options]
      resources :aside_after_main_widgets, only: [:index, :show, :create, :update, :destroy]

      match :footer_widgets, to: 'footer_widgets#options', via: [:options]
      match "footer_widgets/:id", to: 'footer_widgets#options', via: [:options]
      resources :footer_widgets, only: [:index, :show, :create, :destroy]

      resources :web_home_templates, only: [:index, :show, :update]

      match :web_page_templates, to: 'web_page_templates#options', via: [:options]
      match "web_page_templates/:id", to: 'web_page_templates#options', via: [:options]
      resources :web_page_templates, only: [:index, :show, :create, :update, :destroy, :options]

      match :main_widgets, to: 'main_widgets#options', via: [:options]
      match "main_widgets/:id", to: 'main_widgets#options', via: [:options]
      resources :main_widgets, only: [:index, :show, :create, :update, :destroy]

      match "assets", to: 'assets#options', via: [:options]
      match "assets/:id", to: 'assets#options', via: [:options]
      resources :assets, only: [:index, :show, :create, :update, :destroy]

      resources :categories, only: [:index, :show]

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
  get "/:location_slug/assets", to: "locations#index"
  get "/:location_slug/:web_page_template_slug/edit", to: "locations#index"
  get "/:urn/:vertical_slug/:state_slug/:city_slug", to: "web_templates#show"
  get "/:urn/:vertical_slug/:state_slug/:city_slug/:web_template_slug", to: "web_templates#show"
  get "/:vertical_slug/:state_slug/:city_slug/:owner_urn/:web_template_slug", to: "web_templates#show"
  get "/:urn/:vertical_slug/:state_slug/:city_slug/:owner_urn/:web_template_slug", to: "web_templates#show"

  # Root to Ember.js application
  root to: "locations#index"
end

