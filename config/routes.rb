Rails.application.routes.draw do
  resources :enrollments, expect: [:new,:create] do
    get :my_students, on: :collection
  end  
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection 
    member do
      get :statistics
      patch :approve
      patch :unapprove
    end  
    resources :lessons
    resources :enrollments, only: [:new,:create]
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "activity", to: "home#activity" 
  get "statistics", to: "home#statistics"

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end

end
