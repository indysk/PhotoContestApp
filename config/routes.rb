Rails.application.routes.draw do
  root 'contests#index'
  resources :contests, except: [:index]
  resources :photos

  devise_for(
    :users,
    path: '',
    module: 'users',
    path_names: { registration: 'users' }
  )
  devise_scope :user do
    get 'users/:id', to: 'users/registrations#show', as: 'user'
  end

end
