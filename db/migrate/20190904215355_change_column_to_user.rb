class ChangeColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, comment: 'ユーザ名'
    add_column :users, :last_name, :string, comment: '姓', limit: 30
    add_column :users, :first_name, :string, comment: '名', limit: 30
    add_column :users, :tel, :string, comment: '電話番号', limit: 45
    add_column :users, :display_name, :string, comment: '表示名', limit: 30
    add_column :users, :password, :string, comment: 'パスワード', limit: 50
    add_column :users, :parent_id, :integer, length: 11, comment: '親ユーザID'
    add_column :users, :db_auth_registration_completed, :boolean, comment: 'DB認証利用ユーザ登録フラグ'
  end
end
