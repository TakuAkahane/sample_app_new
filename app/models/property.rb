# encoding: utf-8
# frozen_string_literal: true

class Property < ApplicationRecord
  # 列挙型カラム向け gem 利用
  include PropertyType
  include AreaId
  include Layout
  include BalconyDirection
  include RightsConceningLand

  # 複数選択可能にするには、activerecord内で以下のserialize定義が必要
   serialize :property_type, Array
   serialize :area_id, Array
   serialize :layout, Array
   serialize :balcony_direction, Array

end
