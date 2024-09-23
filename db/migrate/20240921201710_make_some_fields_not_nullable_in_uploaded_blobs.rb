class MakeSomeFieldsNotNullableInUploadedBlobs < ActiveRecord::Migration[7.2]
  def change
    change_column_null :uploaded_blobs, :blob_id, false
    change_column_null :uploaded_blobs, :file_size, false
    change_column_null :uploaded_blobs, :checksum, false
    change_column_null :uploaded_blobs, :backend_storage, false
  end
end
