class BaseCustomError < StandardError
  attr_reader :status

  def initialize(message = nil, status: :unprocessable_entity)
    super(message)
    @status = status
  end
end