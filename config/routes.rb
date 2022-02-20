Rails.application.routes.draw do
  get 'albums/draft'

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
  
  root "albums#index"
end
