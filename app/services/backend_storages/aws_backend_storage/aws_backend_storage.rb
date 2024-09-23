require_relative '../backend_storage'
require_relative 'aws_client'
require_relative '../../../errors/blob_upload_error'
require_relative '../../../errors/blob_retrieve_error'


class AwsBackendStorage
  include BackendStorage

  def upload_blob(blob_id, blob_data)
    res = AwsClient.new(http_method: 'PUT',path: blob_id, body:blob_data).make_request
    unless res.code == '200'
      raise BlobUploadError
    end
  end

  def retrieve_blob(uploaded_blob)
    res = AwsClient.new(http_method: 'GET',path: uploaded_blob.blob_id).make_request
    unless res.code == '200'
      raise BlobRetrieveError
    end
    res.body
  end
end

