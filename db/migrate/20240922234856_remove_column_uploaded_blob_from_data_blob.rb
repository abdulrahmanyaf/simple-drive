class RemoveColumnUploadedBlobFromDataBlob < ActiveRecord::Migration[7.2]
  def change
    remove_column :data_blobs, :uploaded_blob_id, :integer
  end
end
