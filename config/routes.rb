Rails.application.routes.draw do
  resources :wikis, path: '/', id: /[^\s]+/
end
