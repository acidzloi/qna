require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "oauth_callbacks" }

  root to: "questions#index"

  devise_scope :user do
    post "/send_email" => "oauth_callbacks#send_email"
  end

  concern :voteble do
    member do
      post :vote_up, :vote_down
      delete :recall
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :commenteble do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[voteble commenteble], shallow: true do
    resources :answers, concerns: %i[voteble commenteble], only: %i[ new create destroy update] do
      patch :best, on: :member
    end

    resources :subscriptions, only: %i[ create destroy ]
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        get :answers, on: :member

        resources :answers, shallow: true, except: %i[new edit index]
      end
    end
  end
end
