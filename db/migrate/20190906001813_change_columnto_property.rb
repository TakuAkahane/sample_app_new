class ChangeColumntoProperty < ActiveRecord::Migration[5.2]
  def change
    change_column :properties, :prefecture_id, :string, null: true, comment: '都道府県ID'
  end
end
