# frozen_string_literal: true

class ChecksumValidator
  def initialize(data, checksum)
    @data = data
    @checksum = checksum
  end

  def valid?
    Digest::SHA256.hexdigest(@data) == @checksum
  end
end
