Rails.application.routes.draw do
  root "questions#index"

  concern :voteble do
    member do
      post :vote_up, :vote_down
      delete :recall
    end
  end

  devise_for :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, concerns: :voteble do
    resources :answers, concerns: :voteble, shallow: true, only: %i[ new create destroy update] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
end
