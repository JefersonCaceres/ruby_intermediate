Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/health', to: 'health#health'
  # Defines the root path route ("/")
  # root "articles#index"
## podemos definir todos los metodos de un crud
  resources :posts, only:[:index, :show, :create, :update]

  ##para mirar si estan correctamente las rutas usamos
  ## este comando {rails routes} en la terminal

  ###CONSEJO
  ## cuando la app es muy grande podemos buscar con este comando
  ## rails routes | grep "posts" solo en linux
end
