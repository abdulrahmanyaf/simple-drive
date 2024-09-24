require_relative '../backend_storage'
require_relative 'ftp_client'
require_relative '../../../errors/blob_upload_error'
require_relative '../../../errors/blob_retrieve_error'


class FtpBackendStorage
  include BackendStorage

  def upload_blob(blob_id, blob_data)
    is_uploaded = FTPClient.upload_binary_data(blob_id, blob_data)
    unless is_uploaded
      raise BlobUploadError
    end
  end

  def retrieve_blob(blob_id)
    data = FTPClient.retrieve_binary_data(blob_id)
    unless data
      raise BlobRetrieveError
    end
    data
  end
end

