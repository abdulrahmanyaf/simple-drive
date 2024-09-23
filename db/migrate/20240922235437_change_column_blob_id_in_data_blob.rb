class ChangeColumnBlobIdInDataBlob < ActiveRecord::Migration[7.2]
  def change
    change_column_null :data_blobs, :blob_id, false
  end
end
