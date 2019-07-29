# encoding: utf-8
# frozen_string_literal: true

Rails.application.routes.draw do

  # 物件
  resources :properties

  # ユーザ関連
  resources :users, only: %i[edit update]

  # devise関連
  devise_for :users, path: 'users',
                     controllers: {
                       users: 'users',
                       omniauth_callbacks: 'users/omniauth_callbacks',
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       confirmations: 'users/confirmations',
                       unlocks: 'users/unlocks',
                       passwords: 'users/passwords'
                     }

  devise_scope :user do
    get 'manage/users/edit_account_type' => 'users#edit_account_type'
    get 'users/auth/sns_auth' => 'users/omniauth_callbacks#sns_auth'
    get 'users/password/editpass' => 'users/passwords#edit'
    put 'users/password/updatepass' => 'users/passwords#update'
    post 'users/sign_in' => 'users/sessions#create'
    get 'users/registrations' => 'users/registrations#index'
    get 'users/profile/edit_password' => 'users/registrations#edit_profile_password'
    patch 'users/profile/change_password' => 'users/registrations#edit_profile_email'
    get 'users/profile/edit_email' => 'users/registrations#edit_profile_email'
    patch 'users/profile/change_email' => 'users/registrations#change_profile_email'
    get 'users/profile/edit_email_reception_settings' => 'users/registrations#edit_mail_reception_settings'
    patch 'users/profile/change_mail_reception_settings' => 'users/registrations#change_mail_reception_settings'
    get 'users/thanks_email' => 'users/registrations#thanks'
    get 'users/thanks_google' => 'users/registrations#tracking'
    get 'users/thanks_facebook' => 'users/registrations#tracking'
  end

  # 本体側からシステム管理側の routing を呼び出す場合、 renopertyadmin.XXX にする
  mount Renopertyadmin::Engine, at: '/renopertyadmin', as: 'renopertyadmin'
end
