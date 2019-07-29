class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.string :property_name, comment: '物件名', :null => false
      t.string :prefecture_id, comment: '都道府県ID', :null => false
      t.string :area, comment: '地域', :null => false
      t.string :address, comment: '住所', :null => false
      t.integer :price, comment: '金額', :null => false
      t.string :layout, comment: '間取り', :null => false
      t.integer :exclusive_area_size, comment: '専有面積', :null => false
      t.integer :floore_level, comment: '階数', :null => false
      t.datetime :completion_date, comment: '建築日', :null => false
      t.string :property_type, comment: '住居タイプ', :null => false
      t.integer :balcony_size, comment: 'ベランダ面積', :null => true
      t.string :balcony_direction, comment: 'ベランダ向き', :null => false
      t.integer :total_number_of_houses, comment: '総住戸数', :null => false
      t.string :rights_concening_land, comment: '権利', :null => false
      t.string :management_company, comment: '管理会社名', :null => true
      t.integer :management_fee, comment: '管理費', :null => false
      t.integer :repair_reserve_fund, comment: '修繕積立金', :null => false
      t.datetime :handover_date, comment: '引き渡し日', :null => false
      t.text :transportation, comment: '交通手段', :null => false
      t.timestamps
    end
  end
end
