Rails.application.routes.draw do
  #ルート++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  root 'contests#index'
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  #コンテスト+++++++++++++++++++++++++++++++++++++++++++++++++++++
  resources :contests, except: [:index] do
    #コンテストに紐付けられた写真
    resources :photos
    #コンテストに紐付けられた投票
    resources :votes, only: [:index, :create, :destroy]
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

  #ユーザに紐付けられた写真++++++++++++++++++++++++++++++++++++++++
  resources :users, only: [] do
    resources :photos, only: [:show, :edit, :update, :destroy]
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  #限定公開URL制御++++++++++++++++++++++++++++++++++++++++
  patch 'url', to: 'urls#update'
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end
