Rails.application.routes.draw do
  root 'sequences#input'
  get 'sequences/output'
  resources :sequences
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
