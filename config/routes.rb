# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get '/users_quizzes', to: 'quizzes#users_quizzes'
  resources :quizzes, only: %i[new create edit update show index]
  resources :quizzes do
    resources :compass_photos, only: %i[new create destroy]
    resources :responses, only: %i[new index]
  end
  resources :responses, only: %i[create show]
  devise_for :users
  resources :users, only: [:show, :index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
