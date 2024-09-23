require Rails.root.join('app', 'services', 'utils', 'base64_encoder').to_s

class Base64EncoderTest < ActiveSupport::TestCase

  test "test the base64 encoder" do
    data = "Hello Simple Storage World!"
    encoded_data = "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh"
    assert_equal encoded_data, Base64Encoder.new(data, nil).base64_code
  end

end
