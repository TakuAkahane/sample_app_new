# encoding: utf-8
# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # 本体側からシステム管理側の routing を呼び出す場合、 renopertyadmin.XXX にする
  mount Renopertyadmin::Engine, at: '/renopertyadmin', as: 'renopertyadmin'
end
