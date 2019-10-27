# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Renopertyadmin::CompaniesController, type: :controller do
  routes { Renopertyadmin::Engine.routes }

  describe 'GET #index 初期表示' do
    before do
      create(:company)
      get :index
    end
    it 'リクエストは200 OKになること' do
      expect(response.status).to eq 200
    end
    it '@companiesが1件取得されること' do
      expect(assigns(:companies).length).to eq 1
    end
    it ':indexテンプレートを表示すること' do
      expect(response).to render_template :index
    end
  end
end
