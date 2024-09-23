require 'openssl'
require 'net/http'
require 'uri'
require 'base64'
require 'cgi'

class AwsClient

  def initialize(http_method:, path:, request_parameters: nil, body: nil, date: Time.now.utc)
    #This AwsClient Is only accepting two http_methods GET, PUT
    @access_key = ENV['AWS_ACCESS_KEY_ID']
    @secret_key = ENV['AWS_SECRET_ACCESS_KEY']
    @region = ENV['AWS_REGION']
    @service = ENV['AWS_SERVICE']
    @http_method = http_method
    uri = URI.parse(ENV['AWS_SERVICE_API_URL'] + '/' + path)
    @host = uri.host
    @canonical_uri = uri.path
    @port = uri.port
    @request_parameters = request_parameters || ""
    @body = body
    @date = date
  end

  def make_request
    https = Net::HTTP.new(@host, @port)
    https.use_ssl = true
    https.request(request)
  end

  private

  def request
    case @http_method
    when 'GET'
      request = Net::HTTP::Get.new("#{@canonical_uri}#{'?' + @request_parameters}")
    when 'PUT'
      request = Net::HTTP::Put.new("#{@canonical_uri}")
      request.body = @body
    else
      raise "Not Supported Method: #{@http_method}"
    end
    request_fields.each do |key, value|
      request.add_field key, value
    end
    request
  end

  def request_fields
    {
      'Content-Type': "application/octet-stream",
      'X-Amz-Date': amz_date,
      'X-Amz-Content-Sha256': payload_hash,
      'Authorization': auth_header,
    }
  end

  private

  def canonical_headers
    ['content-type:application/octet-stream',
     'host:' + @host, "x-amz-content-sha256:#{payload_hash}",
     'x-amz-date:' + amz_date].join("\n") + "\n"
  end

  def signed_headers
    'content-type;host;x-amz-content-sha256;x-amz-date'
  end

  def canonical_request
    [@http_method, @canonical_uri, @request_parameters, canonical_headers,
     signed_headers, payload_hash].join("\n")
  end

  def algorithm
    'AWS4-HMAC-SHA256'
  end

  def credential_scope
    [datestamp, @region, @service, 'aws4_request'].join("/")
  end

  def string_to_sign
    [algorithm, amz_date, credential_scope, canonical_request_hash].join("\n")
  end

  def signature
    hmac_hexd(get_signature_key, string_to_sign)
  end

  def auth_header
    "#{algorithm} Credential=#{@access_key + '/' + credential_scope}, SignedHeaders=#{signed_headers}, Signature=#{signature}"
  end

  def amz_date()
    @date.strftime('%Y%m%dT%H%M%SZ')
  end

  def datestamp
    @date.strftime('%Y%m%d')
  end

  def payload_hash
    sha256_hash(@body || "")
  end

  def canonical_request_hash
    sha256_hash(canonical_request)
  end

  def sha256_hash(data)
    OpenSSL::Digest::Digest.new("sha256").hexdigest(data)
  end

  def get_signature_key
    k_date = hmac("AWS4" + @secret_key, datestamp)
    k_region = hmac(k_date, @region)
    k_service = hmac(k_region, @service)
    hmac(k_service, 'aws4_request')
  end

  def hmac(key, data)
    OpenSSL::HMAC.digest('sha256', key, data)
  end

  def hmac_hexd(key, data)
    OpenSSL::HMAC.hexdigest('sha256', key, data)
  end
end
