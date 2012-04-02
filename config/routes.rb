TrainingGrant::Application.routes.draw do

  resources :applicants

  resources :preceptors

  devise_for :users, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords' }, path_names: { sign_up: 'register', sign_in: 'login' }

  resources :users

  match "/about" => "sites#about", as: :about
  match "/settings" => "users#settings", as: :settings

  root to: 'sites#dashboard'

end
