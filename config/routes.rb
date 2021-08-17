Rails.application.routes.draw do
  #ルート++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  root 'contests#index'
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  #ユーザ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  devise_for(
    :users,
    path: '',
    module: 'users',
    path_names: { registration: 'users' }
  )
  devise_scope :user do
    get 'users/:id', to: 'users/registrations#show', as: 'user'
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  #コンテスト+++++++++++++++++++++++++++++++++++++++++++++++++++++
  resources :contests, except: [:index] do
    #コンテストに紐付けられた写真
    resources :photos
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  #ユーザに紐付けられた写真++++++++++++++++++++++++++++++++++++++++
  resources :users, only: [] do
    resources :photos
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end
