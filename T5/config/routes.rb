Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root "search#index"

  get 'livros/emprestados', to: 'livros#list', as: 'livros_emprestados'
  get 'carteirinhas/emprestimos', to: 'carteirinhas#list', as: 'carteirinhas_emprestimos'
  
  resources :pessoas
  resources :carteirinhas
  resources :autors do
    collection do
      get :autocomplete
    end
  end

  resources :livros do
    collection do
      get :autocomplete
    end
  end

  get "search", to: "search#index"
  get "search/autocomplete", to: "search#autocomplete"
  
  resources :carteirinhas do
    member do
      get "livros"
    end
  end

  
  resources :carteirinhas_livros 
  get   'login', to:  'sessions#login'
  post 'login', to:  'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'logout', to: 'sessions#destroy'
  
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
