Rails.application.routes.draw do
  root "questions#index"

  devise_for :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end
end
