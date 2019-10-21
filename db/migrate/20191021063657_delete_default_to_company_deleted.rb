class DeleteDefaultToCompanyDeleted < ActiveRecord::Migration[5.2]
  def change
    change_column_null :companies, :deleted, true
  end
end
