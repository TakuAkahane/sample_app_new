# encoding: utf-8
# frozen_string_literal: true

#----------------------------------------------------------------------------#
# 列挙型カラムの要素定義 config/locale/ja.yml の enumerize と対応
#----------------------------------------------------------------------------#
# 住居タイプ
module PropertyType
  extend Enumerize
  enumerize :property_type, in: %i[unit_apartment whole_building_apartment house],
                            multiple: true
end
# 区ID
module AreaId
  extend Enumerize
  enumerize :area_id, in: %i[minato chuo chiyoda shibuya shinjuku bunkyo],
                      multiple: true
end
# 間取り
module Layout
  extend Enumerize
  enumerize :layout, in: %i[1r 1k 1dk 1ldk 2k 2dk 2ldk 3k 3dk 3ldk
                                 4k 4dk 4ldk 5k 5dk 5ldk], multiple: true
end
# ベランダ向き
module BalconyDirection
  extend Enumerize
  enumerize :balcony_direction, in: %i[east west south north], multiple: true
end
# 権利
module RightsConceningLand
  extend Enumerize
  enumerize :rights_concening_land, in: %i[ownership leasehod], multiple: false
end

#----------------------------------------------------------------------------#
# Activerecord 基底クラス
#----------------------------------------------------------------------------#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
