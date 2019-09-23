class ChangeDataCompletionDateToProperty < ActiveRecord::Migration[5.2]
  def change
    change_column :properties, :completion_date, :date
    change_column :properties, :handover_date, :date
  end
end
