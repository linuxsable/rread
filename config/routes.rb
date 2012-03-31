Rread::Application.routes.draw do
  root :to => 'home#index'

  # Ajax read status
  match '/article/read' => 'article#read'
  match '/article/like' => 'article#like'

  match '/subscriptions/create' => 'subscriptions#create'
  match '/subscriptions/destroy' => 'subscriptions#destroy'

  match '/reader/import_greader' => 'reader#import_greader'
  match '/reader/mark_all_as_read' => 'reader#mark_all_as_read'
  
  resources :home, :user, :reader, :sessions, :blog, :article
  
  # Sessions stuff
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout

  # Resque pannel
  mount Resque::Server, :at => '/resque'

  # Static pages
  match ':action' => 'static#:action'
end
