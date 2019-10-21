class ChangeDataDeletedToCompany < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :tel, :string, limit: 45
  end
end
