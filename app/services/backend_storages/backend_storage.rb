module  BackendStorage

  def upload_blob(blob_id, blob_data)
    raise NotImplementedError, "The method #{__method__} is not implemented for #{self.class}"
  end

  def retrieve_blob(uploaded_blob)
    raise NotImplementedError, "The method #{__method__} is not implemented for #{self.class}"
  end

end


