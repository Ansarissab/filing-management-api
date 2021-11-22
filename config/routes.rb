Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :filings, only: %w(index)
    resources :receivers, only: %w(index)
  end
end
