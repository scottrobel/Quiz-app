# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get '/users_quizzes', to: 'quizzes#users_quizzes'
  get '/random_quiz', to: 'responses#take_random_quiz'
  resources :quizzes, only: %i[new create edit update show index destroy]
  resources :quizzes do
    resources :compass_photos, only: %i[new create destroy edit update]
    resources :responses, only: %i[new index]
    resources :features, only: [:create, :destroy]
  end
  resources :responses, only: %i[create show]
  devise_for :users
  resources :users, only: [:show, :index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
