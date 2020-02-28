Rails.application.routes.draw do
  root to: 'pages#home'
  resources :quizzes, only: [:new, :create, :edit, :update, :index, :show]
  resources :quizzes do
    resources :responses, only: [:new, :index]
  end
  resources :responses, only: [:create, :show]
  devise_for :users
  resources :users, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
