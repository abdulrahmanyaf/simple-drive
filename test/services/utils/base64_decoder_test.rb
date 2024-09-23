require Rails.root.join('app', 'services', 'utils', 'base64_decoder').to_s

class Base64DecoderTest < ActiveSupport::TestCase

  def setup
    @data = "Hello Simple Storage World!"
    @data_size = 27
    @encoded_data = "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh"
  end

  test "test the base64 decoder to get the correct decoded data" do
    assert_equal @data, Base64Decoder.new(@encoded_data).decoded_data
  end

  test "test the base64 decoder to get the correct data size" do
    assert_equal @data_size, Base64Decoder.new(@encoded_data).data_size
  end

end

