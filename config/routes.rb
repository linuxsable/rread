Rread::Application.routes.draw do
  root :to => 'home#index'

  # Ajax read status
  match '/articles/read' => 'articles#read'
  match '/articles/like' => 'articles#like'

  match '/subscriptions/create' => 'subscriptions#create'
  match '/subscriptions/destroy' => 'subscriptions#destroy'

  match '/reader/import_greader' => 'reader#import_greader'
  match '/reader/mark_all_as_read' => 'reader#mark_all_as_read'
  match '/reader/article_feed' => 'reader#article_feed'
  
  resources :home, :user, :reader, :sessions, :blog, :articles
  
  # Sessions stuff
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout

  # Resque pannel
  mount Resque::Server, :at => '/resque'

  # Static pages
  match ':action' => 'static#:action'
end
