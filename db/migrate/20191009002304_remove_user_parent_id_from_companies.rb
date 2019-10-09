class RemoveUserParentIdFromCompanies < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :user_parent_id, :integer
  end
end
