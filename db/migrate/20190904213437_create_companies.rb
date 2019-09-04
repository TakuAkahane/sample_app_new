class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :ward_id, comment: '区ID', :null => false
      t.string :address, comment: '住所詳細', :null => false
      t.string :name, comment: '名前', :null => false
      t.integer :tel, comment: '電話番号', :null => false
      t.string :public, comment: '公開/非公開', :null => false
      t.integer :establishment, comment: '設立年', :null => true
      t.text :description, comment: '概要', :null => true
      t.boolean :deleted, comment: '削除フラグ', :null => true, :default => false
      t.string :company_size_id, comment: '企業規模識別子', :null => true
      t.integer :user_parent_id, comment: '親ユーザID', :null => false

      t.timestamps
    end
  end
end
