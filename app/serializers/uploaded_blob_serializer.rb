require_relative '../services/utils/date_utils'
class UploadedBlobSerializer < ActiveModel::Serializer
  attributes :id, :size, :created_at

  def id
    object.blob_id
  end

  def created_at
    DateUtils.format_datetime(object.created_at)
  end
end