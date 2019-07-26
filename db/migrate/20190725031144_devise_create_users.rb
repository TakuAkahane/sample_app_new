# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: "", comment: 'email - SNS認証時取込有'
      t.string :encrypted_password, null: false, default: "", comment: '暗号化パスワード'

      ## Recoverable
      t.string   :reset_password_token, comment: 'パスワード再設定用トークン'
      t.datetime :reset_password_sent_at, comment: 'パスワード再設定用トークン送信日時'

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false, comment: 'サインイン回数'
      t.datetime :current_sign_in_at, comment: '最新サインイン日時'
      t.datetime :last_sign_in_at, comment: '最新1つ前のサインイン日時'
      t.string   :current_sign_in_ip, comment: '最新サインインIP'
      t.string   :last_sign_in_ip, comment: '最新1つ前のサインインIP'

      ## Confirmable
      t.string   :confirmation_token, comment: '確認用トークン'
      t.datetime :confirmed_at, comment: '確認完了日時'
      t.datetime :confirmation_sent_at, comment: '確認メール送信日時'
      t.string   :unconfirmed_email, comment: '未確認メールアドレス'

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at, comment: 'ロックアウト日時'


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
