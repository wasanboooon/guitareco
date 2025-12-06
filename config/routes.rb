# config/routes.rb
Rails.application.routes.draw do
  get "guitar/index"
  devise_for :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Helloページ
  get "hello/index" => "hello#index"
  get "hello/link"  => "hello#link"

  # Tweet ＋ Like
  resources :tweets do
    resource :like, only: [ :create, :destroy ]
  end

  # 診断フォーム
  get  "diagnoses/new",    to: "diagnoses#new",    as: :new_diagnosis
  get  "diagnoses/result", to: "diagnoses#result", as: :diagnoses_result
  post "diagnoses/result", to: "diagnoses#result"

  get "guitar", to: "guitar#index"


  # ルート（トップページ）
  root "hello#index"
end
