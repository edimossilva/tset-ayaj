Rails.application.routes.draw do
  resources :github_webhooks, only: [:create, :index]
end
