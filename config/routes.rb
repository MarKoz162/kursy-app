Rails.application.routes.draw do
 
  resources :enrollments
  devise_for :users
  resources :courses do
    resources :lessons
  end
  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "activity", to: "home#activity" 
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
