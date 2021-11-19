Rails.application.routes.draw do
  resources :enrollments, expect: [:new,:create] do
    get :my_students, on: :collection
  end  
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection 
    member do
      get :statistics
      patch :approve
      patch :unapprove
    end  
    resources :lessons do
      resources :comments, only: [:create, :destroy]
      put :sort
    end  
    resources :enrollments, only: [:new,:create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
  get "activity", to: "home#activity" 
  get "statistics", to: "home#statistics"
  get "privacy_policy", to: "home#privacy_policy"

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end
  
  resources :tags, only: [:create, :index, :destroy]
  resources :course_creator
  
end
