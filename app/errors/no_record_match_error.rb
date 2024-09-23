require_relative 'base_custom_error'

class NoRecordMatchError < BaseCustomError
  def initialize(message = "The record does not exists", status: :not_found)
    super(message, status: status)
  end
end