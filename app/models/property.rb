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

   # validates
   validates :property_name, presence: true
   validates :address, presence: true
   validates :price, presence: true
   validates :exclusive_area_size, presence: true
   validates :floore_level, presence: true
   validates :completion_date, presence: true
   validates :property_type, presence: true
   validates :area_id, presence: true
   validates :layout, presence: true
   validates :balcony_size, presence: true
   validates :balcony_direction, presence: true
   validates :total_number_of_houses, presence: true
   validates :rights_concening_land, presence: true
   validates :management_company, presence: true
   validates :management_fee, presence: true
   validates :repair_reserve_fund, presence: true
   validates :handover_date, presence: true
   validates :transportation, presence: true

end
