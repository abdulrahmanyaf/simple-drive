# frozen_string_literal: true

class Base64Decoder
  attr_reader :decoded_data, :content_type

  def initialize(base64_code)
    @encoded_data, @content_type = parse_blob_data(base64_code)
    begin
      @decoded_data = Base64.decode64(@encoded_data)
    rescue ArgumentError
      raise Base64DecoderError
    end
  end

  def data_size
    @decoded_data.bytesize
  end

  def checksum
    Digest::SHA256.hexdigest(@decoded_data)
  end

  def parse_blob_data(blob_data)
    if blob_data.start_with?("data:")
      metadata, encoded_data = blob_data.split(',', 2)
      content_type = metadata.match(/data:(.*?);/)[1]
    else
      encoded_data = blob_data
      content_type = nil
    end
    return encoded_data, content_type
  end
end
