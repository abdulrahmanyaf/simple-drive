require_relative 'base_custom_error'
class Base64DecoderError < BaseCustomError
  def initialize(message = "Invalid Base64 format", status: :bad_request)
    super(message, status: status)
  end
end