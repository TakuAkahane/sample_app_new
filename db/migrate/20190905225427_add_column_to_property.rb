class AddColumnToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :ward_id, :string, comment: '区ID'
  end
end
