Rails.application.routes.draw do
  resources :quizzes, only: [:new, :create, :edit, :update, :index]
  resources :quizzes do
    resources :responses, only: [:new, :index]
  end
  resources :responses, only: [:create, :show]
  root to: 'pages#home'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
