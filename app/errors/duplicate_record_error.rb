require_relative 'base_custom_error'

class DuplicateRecordError < BaseCustomError
  def initialize(message = "There ia already record exists with the same info", status: :unprocessable_entity)
    super(message, status: status)
  end
end