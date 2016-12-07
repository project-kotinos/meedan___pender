require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :medias, only: [:index, :screenshots]
      #get 'medias/index', to: 'medias#index'
      #get 'medias/screenshots', to: 'medias#screenshots'
    end
  end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web, at:'/sidekiq'
end
