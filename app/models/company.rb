# encoding: utf-8
# frozen_string_literal: true

class Company < ApplicationRecord
  # 列挙型カラム向け gem 利用
  include WardId
  include Public
  include CompanySizeId

  # validates
  validates :address, presence: true
  validates :ward_id, presence: true
  validates :name, presence: true
  validates :tel, presence: true
  validates :public, presence: true
  validates :establishment, presence: true
  validates :description, presence: true
  validates :company_size_id, presence: true

end
