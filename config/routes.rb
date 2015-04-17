LibraryCollection::Application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }, :controllers => {:registrations => "registrations"}
  resources :books
  resources :genres
  resources :authors
  resources :keywords
  resources :book_uploads, only: [:new, :create]
  resources :user_uploads, only: [:new, :create]
  resources :users, only: [ :update, :destroy, :edit, :show, :index ], path: 'manage_users'
  resources :loans, only: [ :show, :index, :new, :create ]

  get 'uploaded_books' => 'book_uploads#uploaded_books'
  get 'uploaded_users' => 'user_uploads#uploaded_users'
  get 'search' => 'search#search'
  get 'import' => 'search#import'
  post 'scrape' => 'search#scrape'
  get 'new_multi' => 'loans#new_multi'
  post 'loan_multi' => 'loans#loan_multi'
  post 'renew' => 'loans#renew'
  post 'return' => 'loans#return'
  get 'overdue_list' => 'loans#overdue_list'
  post 'list' => 'books#list', defaults: {format: :json}
  get 'clear_list' => 'books#clear_list', defaults: {format: :js}
  get 'show_list' => 'books#show_list'
  post 'send_reminders' => 'users#send_reminders'
  post 'generate_report' => 'document_generator#new_report'

  get 'admin_dashboard' => 'static_pages#admin_dashboard'
  get 'styleguide' => 'static_pages#styleguide'
  get 'user_guide' => 'static_pages#user_guide'

  root to: 'static_pages#home'

end
