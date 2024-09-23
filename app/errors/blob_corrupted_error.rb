require_relative 'base_custom_error'

class BlobCorruptedError < BaseCustomError
  def initialize(message = "The blob is corrupted", status: :internal_server_error)
    super(message, status: status)
  end
end