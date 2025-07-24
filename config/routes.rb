# frozen_string_literal: true
#require('sidekiq-ent/web')

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  scope module: 'api' do
    namespace :v1 do
      namespace :customer do
        match '/lease_history' => 'lease_history#index', via: :post
      end
    end
  end

  get '/status', to: proc { [200, {}, ['OK']] }

  mount Rswag::Api::Engine => '/api-docs' unless Rails.env.production?
  mount Rswag::Ui::Engine => '/api-docs' unless Rails.env.production?

  match '*path', to: 'invalid_route#index', via: :all
end
