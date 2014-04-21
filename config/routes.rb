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
      resources :clients, only: [:show]
      resources :locations, only: [:index, :show]
      resources :websites, only: [:index, :show]

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
    end
  end

  # TODO: move to API endpoint
  resources :websites, only: [] do
    member do
      post "deploy"
    end
  end

  # Widget edit modals
  resources :widgets, only: [:edit, :update]

  # WidgetEntry is published for new form widget
  resources :widget_entries, only: [:index, :show]
  resources :tags, only: [:show]

  # G5SiblingDeployerEngine routes shouldn't need to be explicitly added
  resources :siblings, only: [:index] do
    member do
      post "deploy"
    end
  end
  get "siblings/instructions" => "siblings/instructions#index", as: :siblings_instructions
  get "siblings/deploys" => "siblings/deploys#index", as: :siblings_deploys
  post "webhooks/g5-configurator" => "webhooks#g5_configurator", as: :g5_configurator_webhook

  # Ember.js application
  get "/:location_slug", to: "locations#index"
  get "/:location_slug/:web_page_template_slug", to: "locations#index"
  get "/:vertical_slug/:state_slug/:city_slug", to: "web_templates#show"
  get "/:vertical_slug/:state_slug/:city_slug/:web_template_slug", to: "web_templates#show"

  # Root to Ember.js application
  root to: "locations#index"
end
