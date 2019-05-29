Rails.application.routes.draw do
  root to: 'users#search'

  get 'users/search/(:username)', to: 'users#search', as: :users_search_by_username
end
