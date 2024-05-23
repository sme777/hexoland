Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/' => 'user#index', as: :home
  get '/studio' => 'studio#index', as: :studio
  get '/feed' => 'feed#index', as: :feed

  post '/studio/' => 'studio#create', as: :create_assembly
  
end
