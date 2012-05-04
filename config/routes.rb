TrainingGrant::Application.routes.draw do

  # devise_for :applicants, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords' }, path_names: { sign_up: 'register', sign_in: 'login' }
  devise_for :applicants, path: 'as', path_names: { sign_up: 'register', sign_in: 'login' }

  resources :applicants do
    collection do
      get :dashboard
      get :edit_me
      put :update_me
    end
    member do
      post :email
    end
  end

  devise_for :preceptors, path: 'ps', path_names: { sign_up: 'register', sign_in: 'login' }

  resources :preceptors do
    collection do
      get :dashboard
      get :edit_me
      put :update_me
    end
    member do
      post :email
    end
  end

  devise_for :users, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords', confirmations: 'contour/confirmations', unlocks: 'contour/unlocks' }, path_names: { sign_up: 'register', sign_in: 'login' }

  resources :users

  match "/about" => "sites#about", as: :about
  match "/settings" => "users#settings", as: :settings

  root to: 'sites#dashboard'

end
