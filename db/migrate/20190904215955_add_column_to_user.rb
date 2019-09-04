class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :company_id, :integer, comment: '会社ID', :null => true
    add_column :users, :individual_use, :boolean, comment: '個人利用フラグ'
  end
end
