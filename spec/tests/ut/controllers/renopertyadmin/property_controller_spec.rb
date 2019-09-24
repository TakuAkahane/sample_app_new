# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

###### 暫定 ######
Rspec.describe PropertiesController, type: :controller do
  describe 'GET #index 初期表示' do
    before do
      create(:property)
      create(:property_2)
      get :index
    end
    it 'リクエストは200 OKになること' do
      expect(response.status).to eq 200
    end
    it '@propertiesが2件取得されること' do
      expect(assigns(:properties).length).to eq 2
    end
    it ':indexテンプレートを表示すること' do
      expect(response).to render_template :index
    end
  end
end
