require_relative 'backend_storage'
require_relative '../../errors/blob_retrieve_error'
require_relative '../../errors/blob_upload_error'

class DatabaseBackendStorage
  include BackendStorage

  def upload_blob(blob_id, blob_data)
    begin
      DataBlob.create(blob_id: blob_id, data: blob_data)
    rescue StandardError => e
      Rails.logger.error("Error while creating the blob:#{blob_id}. E: #{e.message}")
      raise BlobUploadError
    end
  end

  def retrieve_blob(blob_id)
    data_blob = DataBlob.find_by(blob_id: blob_id)
    if data_blob.nil?
      Rails.logger.warn("Blob #{blob_id} is messing from the database storage.")
      raise BlobRetrieveError
    end
    data_blob.data
  end

end