# frozen_string_literal: true

Rails.application.routes.draw do
  resources :annuals do
    member do
      get :edit_me
      put :update_me
    end
  end

  devise_for :applicants,
             path: 'trainee',
             path_names: { sign_up: 'register', sign_in: 'login' }

  resources :applicants do
    collection do
      get :dashboard
      get :edit_me
      get :program_requirements
      put :update_me
      get :exit_interview
      post :update_exit_interview
      post :add_degree
      post :send_annual_reminder_email
    end
    member do
      post :email
      get :annual_email
      post :termination_email
      post :unlock
      post :update_submitted_at_date
      post :help_email
    end
  end

  resources :hospitals

  devise_for :preceptors,
             path: 'preceptor',
             path_names: { sign_up: 'register', sign_in: 'login' }

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

  resources :seminars do
    collection do
      get :attendance
    end
    member do
      post :attended
    end
  end

  devise_for :users,
             controllers: {
               registrations: 'contour/registrations',
               sessions: 'contour/sessions',
               passwords: 'contour/passwords',
               confirmations: 'contour/confirmations',
               unlocks: 'contour/unlocks'
             },
             path_names: {
               sign_up: 'register',
               sign_in: 'login'
             },
             path: ''

  resources :users

  get '/settings' => 'users#settings', as: :settings

  scope module: 'sites' do
    get :about
    get :contact
    get 'forgot-my-password', action: :forgot_my_password,
                              as: :forgot_my_password
    get :dashboard
    get :version
  end

  root to: 'sites#dashboard'
end
