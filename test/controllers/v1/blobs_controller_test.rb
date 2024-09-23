# frozen_string_literal: true
require "rails/test_help"
require Rails.root.join('app', 'services', 'utils', 'date_utils').to_s
require Rails.root.join('app', 'services', 'utils', 'base64_encoder').to_s

class BlobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @jwt_token = generate_jwt_for(@user)
  end

  test "should get the blob details from database storage" do
    blob = uploaded_blobs(:one)
    get v1_blobs_show_url(blob.blob_id), headers: { 'Authorization' => "Bearer #{@jwt_token}" }
    assert_equal({
                   id: blob.blob_id,
                   size: blob.size,
                   created_at: DateUtils.format_datetime(blob.created_at),
                   data: Base64Encoder.new(data_blobs(:one).data, blob.content_type).base64_code }.to_json,
                 @response.body)
  end

  test "should post the blob details to database storage" do
    assert_difference('DataBlob.count', +1) do
      post v1_blobs_create_url,
           headers: {
             'Authorization' => "Bearer #{@jwt_token}"
           },
           params: {
             id: "blob_test_2",
             data: "VGhpcyBpcyBhIHRlc3QgYmxvYiBmb3IgaW50ZWdyYXRpb24gdGVzdGluZw=="
           }
    end
    assert_response :created
  end
end
