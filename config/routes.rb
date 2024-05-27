Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/' => 'user#index', as: :home
  get '/studio' => 'studio#index', as: :studio
  get '/feed' => 'feed#index', as: :feed

  post '/studio/' => 'studio#create', as: :create_assembly
  
  get '/studio/code_assembly' => 'studio#code', as: :code_assembly
  get '/studio/model_assembly' => 'studio#model', as: :model_assembly
  get '/studio/gui_assembly' => 'studio#gui', as: :gui_assembly

  post '/studio/assembly/:id/delete' => 'studio#delete', as: :delete_assembly
  get '/studio/assembly/:id/get_picklist' => 'studio#get_picklist', as: :get_picklist
  
  get '/studio/page_assembly/:page' => 'studio#paginate_assemblies', as: :page_assemblies

end
