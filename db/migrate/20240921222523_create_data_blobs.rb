class CreateDataBlobs < ActiveRecord::Migration[7.2]
  def change
    create_table :data_blobs do |t|
      t.references :uploaded_blob, null: false, foreign_key: true
      t.text :data, null: false

      t.timestamps
    end
  end
end
