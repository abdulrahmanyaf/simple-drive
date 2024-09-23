# frozen_string_literal: true
require Rails.root.join('app', 'services', 'utils', 'checksum_validator').to_s

class ChecksumValidatorTest < ActiveSupport::TestCase
  DATA = "Hello Simple Storage World!"
  CHECKSUM_ONE = '7fc79eaaf401347c1d951de2e124d415bdac232d5645b5a8e783e3791bae419a'
  CHECKSUM_TWO = 'VGhpcyBpcyBhIHRlc3QgYmxvYiBmb3IgaW50ZWdyYXRpb24gdGVzdGluZw=='

  test "test the checksum validation to the same checksum" do
    assert_equal true, ChecksumValidator.new(DATA, CHECKSUM_ONE).valid?
  end

  test "test the checksum validation to different checksum" do
    assert_equal false, ChecksumValidator.new(DATA, CHECKSUM_TWO).valid?
  end
end
