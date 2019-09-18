class RemoveAreaFromProperties < ActiveRecord::Migration[5.2]
  def change
    remove_column :properties, :area, :string
    remove_column :properties, :ward_id, :string
    rename_column :properties, :prefecture_id, :area_id
    change_column :properties, :area_id, :string, null: true, comment: '地域ID'
  end
end
