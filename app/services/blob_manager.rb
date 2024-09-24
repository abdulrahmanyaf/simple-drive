require "base64"
require_relative "backend_storages/local_backend_storage"
require_relative "backend_storages/aws_backend_storage/aws_backend_storage"
require_relative "backend_storages/database_backend_storage"
require_relative "backend_storages/ftb_backend_storage/ftp_backend_storage"
require_relative "utils/base64_decoder"
require_relative "utils/base64_encoder"
require_relative "utils/checksum_validator"
require_relative "../errors/duplicate_record_error"
require_relative "../errors/blob_corrupted_error"
require_relative "../errors/no_record_match_error"
require_relative "../serializers/uploaded_blob_serializer"

class BlobManager

  def self.retrieve_blob(blob_id, user)
    uploaded_blob = user.uploaded_blobs.find_by(blob_id: blob_id)
    if uploaded_blob.nil?
      raise NoRecordMatchError, "You did not upload a blob with this id"
    end

    backend_storage_obj = backend_storage_object(uploaded_blob.backend_storage)
    #TODO: if the blob id is unique for all user just pass the blob_id to the backend_storage_obj.retrieve_blob method
    blob_data = backend_storage_obj.retrieve_blob(uploaded_blob.blob_id)

    # Check if blob was manipulated
    unless ChecksumValidator.new(blob_data, uploaded_blob.checksum).valid?
      raise BlobCorruptedError
    end

    # Encode the blob and serialize it with metadata for the respone
    encoded_blob = Base64Encoder.new(blob_data, uploaded_blob.content_type).base64_code
    serialized_blob = UploadedBlobSerializer.new(uploaded_blob).serializable_hash
    serialized_blob[:data] = encoded_blob
    serialized_blob
  end

  def self.upload_blob(blob_id, blob_data, user)
    if UploadedBlob.exists?(blob_id: blob_id)
      raise DuplicateRecordError, "A blob with the same ID already exists: #{blob_id}"
    end

    # TODO: check if the blob_id is unique in general or per user and fix the filename saving in the local and aws if it is per user
    base64_decoder = Base64Decoder.new(blob_data)
    backend_storage_obj = backend_storage_object

    # used transaction here to either save both uploaded_blob and data_blob or none
    ApplicationRecord.transaction do
      backend_storage_obj.upload_blob(blob_id, base64_decoder.decoded_data)
      add_uploaded_blob_record(blob_id, base64_decoder.content_type, base64_decoder.data_size, base64_decoder.checksum, user)
    end
  end

  private

  def self.add_uploaded_blob_record(blob_id, content_type, size, checksum, user)
    user.uploaded_blobs.create(blob_id: blob_id, content_type: content_type, size: size, checksum: checksum, backend_storage: ENV["ACTIVE_STORAGE_BACKEND"])
  end

  def self.backend_storage_object(backend_storage = nil)
    # backend_storage types: local, aws, database
    case backend_storage || ENV["ACTIVE_STORAGE_BACKEND"]
    when "local"
      return LocalBackendStorage.new
    when "aws"
      return AwsBackendStorage.new
    when "database"
      return DatabaseBackendStorage.new
    when 'ftp'
      return FtpBackendStorage.new
    else
      raise "No backend storage found"
    end
  end

end