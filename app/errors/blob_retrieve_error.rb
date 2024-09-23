require_relative 'base_custom_error'

class BlobRetrieveError < BaseCustomError
  def initialize(message = "The blob could not be retrieved", status: :internal_server_error)
    super(message, status: status)
  end
end