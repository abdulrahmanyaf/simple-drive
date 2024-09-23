class AddColumnBlobIdForDataBlob < ActiveRecord::Migration[7.2]
  def change
    add_column :data_blobs, :blob_id, :string
  end
end
