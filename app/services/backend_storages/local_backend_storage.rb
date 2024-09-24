# frozen_string_literal: true
require_relative 'backend_storage'
require_relative '../../errors/blob_retrieve_error'
require_relative '../../errors/blob_upload_error'

class LocalBackendStorage
  include BackendStorage

  def upload_blob(blob_id, blob_data)
    begin
      file_path = File.join(ENV['LOCAL_STORAGE_DIR'], blob_id)
      File.open(file_path, 'wb') do |file|
        file.write(blob_data)
      end
    rescue => e
      Rails.logger.error("Local file write failed for blob:#{blob_id}. E: #{e.message}")
      raise BlobUploadError
    end
  end

  def retrieve_blob(blob_id)
    file_path = File.join(ENV['LOCAL_STORAGE_DIR'], blob_id)
    begin
      File.read(file_path)
    rescue => e
      Rails.logger.error("Local file read failed for blob:#{blob_id}. E: #{e.message}")
      raise BlobRetrieveError
    end
  end
end