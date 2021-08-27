Rails.application.routes.draw do
  #ルート++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  root 'contests#index'
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  #コンテスト+++++++++++++++++++++++++++++++++++++++++++++++++++++
  resources :contests, except: [:index] do
    #コンテストに紐付けられた写真
    resources :photos, except: [:index, :edit, :update]
    #コンテストに紐付けられた投票
    resources :votes, only: [:show, :new, :create, :destroy]
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
    resources :photos, only: [:show, :destroy]
  end
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end
