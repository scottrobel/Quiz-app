Rails.application.routes.draw do
  root to: 'pages#home'
  get '/users_quizzes', to: 'quizzes#users_quizzes'
  resources :quizzes, only: [:new, :create, :edit, :update, :show, :index]
  resources :quizzes do
    resources :responses, only: [:new, :index]
  end
  resources :responses, only: [:create, :show]
  devise_for :users
  resources :users, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
