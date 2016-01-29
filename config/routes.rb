Rails.application.routes.draw do

  # resources :wikis, id: /.+/

  get    '/wikis'            => 'wikis#index'
  post   '/wikis'            => 'wikis#create'
  get    '/wikis/new'        => 'wikis#new',   as: 'new_wiki'
  get    '/wikis/*page/edit' => 'wikis#edit',  as: 'edit_wiki'
  get    '/wikis/*page'      => 'wikis#show',  as: 'wiki'
  patch  '/wikis/*page'      => 'wikis#update'
  put    '/wikis/*page'      => 'wikis#update'
  delete '/wikis/*page'      => 'wikis#destroy'

end
