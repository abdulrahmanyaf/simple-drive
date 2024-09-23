# frozen_string_literal: true

class Base64Encoder
  attr_reader :decoded_data, :content_type

  def initialize(data, content_type)
    @data = data
    @content_type = content_type
  end

  def base64_code
    base64_data = Base64.strict_encode64(@data)
    @content_type? "data:#{@content_type};base64,#{base64_data}" : base64_data
  end
end
