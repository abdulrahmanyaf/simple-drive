class AddUniqueIndexToUploadedBlobsBlobIdAndChangeFileSizeName < ActiveRecord::Migration[7.2]
  def change
    add_index :uploaded_blobs, :blob_id, unique: true
    rename_column :uploaded_blobs, :file_size, :size
  end
end
