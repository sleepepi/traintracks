# frozen_string_literal: true

Rails.application.routes.draw do
  root "sites#dashboard"

  resources :annuals do
    member do
      get :edit_me
      patch :update_me
    end
  end

  devise_for :applicants,
             controllers: {
               confirmations: "confirmations",
               passwords: "passwords",
               registrations: "registrations",
               sessions: "sessions",
               unlocks: "unlocks"
             },
             path: "trainee",
             path_names: { sign_up: "register", sign_in: "login" }

  resources :applicants do
    collection do
      get :dashboard
      get :edit_me
      get :program_requirements
      patch :update_me
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

  scope module: :external do
    get :privacy_policy, path: "privacy-policy"
  end

  resources :hospitals

  devise_for :preceptors,
               controllers: {
               confirmations: "confirmations",
               passwords: "passwords",
               registrations: "registrations",
               sessions: "sessions",
               unlocks: "unlocks"
             },
             path: "preceptor",
             path_names: { sign_up: "register", sign_in: "login" }

  resources :preceptors do
    collection do
      get :dashboard
      get :edit_me
      patch :update_me
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
               sessions: "sessions",
             },
             path_names: { sign_up: "register", sign_in: "login" },
             path: ""

  resources :users

  get "/settings" => "users#settings", as: :settings

  scope module: "sites" do
    get :about
    get :contact
    get "forgot-my-password", action: :forgot_my_password,
                              as: :forgot_my_password
    get :dashboard
    get :version
  end
end
