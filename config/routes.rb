Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/' => 'feed#index', as: :feed
  get '/studio' => 'studio#index', as: :studio
  get '/docs' => 'docs#index', as: :docs
  get '/inspector' => 'inspector#index', as: :inspector

  post '/studio/' => 'studio#create', as: :create_assembly
  post '/studio/:id/update' => 'studio#update', as: :update_assembly

  # get '/studio/code_assembly' => 'studio#code', as: :code_assembly
  # get '/studio/model_assembly' => 'studio#model', as: :model_assembly
  # get '/studio/gui_assembly' => 'studio#gui', as: :gui_assembly

  get '/studio/forward' => 'studio#forward', as: :forward_assembly
  get '/studio/reverse' => 'studio#reverse', as: :reverse_assembly
  get '/studio/:id/make_public' => 'studio#make_public', as: :make_public
  get '/studio/:id/make_private' => 'studio#make_private', as: :make_private

  get '/studio/search' => 'studio#search', as: :search_assembly

  post '/studio/assembly/:id/delete' => 'studio#delete', as: :delete_assembly
  get '/studio/assembly/:id/get_picklist' => 'studio#get_picklist', as: :get_picklist
  get '/studio/assembly/:id/get_json' => 'studio#get_json', as: :get_json
  
  get '/studio/page_assembly/:page' => 'studio#paginate_assemblies', as: :page_assemblies

  post '/studio/loader' => 'studio#loader'

  get '/feed/:page' => 'feed#index', as: :feed_page

  get '/inspector/:id' => 'inspector#inspect', as: :inspect_assembly

  get '/auth/:provider/callback', to: 'user#create'
  get '/auth/failure', to: 'user#failure'

  get '/auth/twitter' => 'user#create', as: :sign_in_with_twitter
  get '/auth/github' => 'user#create', as: :sign_in_with_github

  get '/auth/sign_out' => 'user#sign_out', as: :sign_out

  get '/:errors' => 'errors#error_404'
end
