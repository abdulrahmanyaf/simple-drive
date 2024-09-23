class CreateUploadedBlobs < ActiveRecord::Migration[7.2]
  def change
    create_table :uploaded_blobs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :blob_id
      t.string :content_type
      t.integer :file_size
      t.string :checksum
      t.string :backend_storage

      t.timestamps
    end
  end
end
