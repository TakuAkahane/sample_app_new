class RecordsarInternalMetadata < ActiveRecord::Migration[5.2]
  def change
    drop_table :ar_internal_metadata
    drop_table :schema_migrations
  end
end
