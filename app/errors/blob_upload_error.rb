require_relative 'base_custom_error'

class BlobUploadError < BaseCustomError
  def initialize(message = "The blob could not be uploaded", status: :internal_server_error)
    super(message, status: status)
  end
end