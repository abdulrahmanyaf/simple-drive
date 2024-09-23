require_relative 'backend_storage'
require_relative '../../errors/blob_retrieve_error'
require_relative '../../errors/blob_upload_error'

class DatabaseBackendStorage
  include BackendStorage

  def upload_blob(blob_id, blob_data)
    begin
      DataBlob.create(blob_id: blob_id, data: blob_data)
    rescue StandardError => e
      raise BlobUploadError
    end
  end

  def retrieve_blob(uploaded_blob)
    data_blob = DataBlob.find_by(blob_id: uploaded_blob.blob_id)
    if data_blob.nil?
      raise BlobRetrieveError
    end
    data_blob.data
  end

end