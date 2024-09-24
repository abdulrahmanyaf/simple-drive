# frozen_string_literal: true
require 'net/ftp'

class FTPClient
  def self.upload_binary_data(blob_id, binary_data)
    ftp = Net::FTP.new
    ftp.connect(ENV['FTP_HOST'], ENV['FTP_PORT'])
    ftp.login(ENV['FTP_USER'], ENV['FTP_PASSWORD'])
    begin
      ftp.chdir(ENV['FTP_STORAGE_DIR'])
      io = StringIO.new(binary_data)
      ftp.storbinary("STOR #{blob_id}", io, Net::FTP::DEFAULT_BLOCKSIZE)
    rescue Net::FTPError => e
      Rails.logger.error("FTP upload failed for blob:#{blob_id}. E: #{e.message}")
      false
    ensure
      ftp.close
    end
    true
  end

  def self.retrieve_binary_data(blob_id)
    ftp = Net::FTP.new
    ftp.connect(ENV['FTP_HOST'], ENV['FTP_PORT'])
    ftp.login(ENV['FTP_USER'], ENV['FTP_PASSWORD'])
    binary_data = StringIO.new
    begin
      ftp.chdir(ENV['FTP_STORAGE_DIR'])
      ftp.retrbinary("RETR #{blob_id}", Net::FTP::DEFAULT_BLOCKSIZE) do |chunk|
        binary_data.write(chunk)
      end
      binary_data.rewind
    rescue Net::FTPError => e
      Rails.logger.error("FTP retrieve failed for blob:#{blob_id}. E: #{e.message}")
      return false
    ensure
      ftp.close
    end
    binary_data.string
  end
end
