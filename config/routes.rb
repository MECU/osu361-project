Rails.application.routes.draw do
  get '/' => 'home#index'
  post '/login' => 'home#login'
  post '/logout' => 'home#logout'
  get '/dashboard' => 'home#dashboard'
  get '/about' => 'home#about'

  get '/search' => 'search#index'
  post '/search-ticker' => 'search#ticker'
  get '/ticker/:ticker' => 'search#details'

  post '/buy' => 'history#buy'
  post '/sell' => 'history#sell'
  post '/edit' => 'history#edit'
  get '/edit-form' => 'history#edit_form'
  post '/delete' => 'history#delete'
end
