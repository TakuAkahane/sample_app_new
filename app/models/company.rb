# encoding: utf-8
# frozen_string_literal: true

class Company < ApplicationRecord
  # 列挙型カラム向け gem 利用
  include WardId
  include Public
  include CompanySizeId

end
