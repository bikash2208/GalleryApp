Rails.application.routes.draw do
  get 'albums/draft'
  get 'albums/home'
  get '/albums/', to: "albums#home"
  get 'albums/search'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  resources :albums do
    member do
      delete :delete_image
    end
  end
  
  root "albums#home"
end
