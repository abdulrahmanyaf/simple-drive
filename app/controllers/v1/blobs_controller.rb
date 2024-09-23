class V1::BlobsController < ApplicationController
  before_action :authenticate_user!

  def create
    missing_params = []
    missing_params << 'id' unless params[:id].present?
    missing_params << 'data' unless params[:data].present?

    if missing_params.any?
      render json: { error: "#{missing_params.join(', ')} field are required" }, status: :bad_request
      return
    end

    begin
      BlobManager.upload_blob(blob_params["id"], blob_params["data"], current_user)
      render json: { success: true }, status: :created
    rescue Exception => e
      if e.is_a?(BaseCustomError)
        render json: { error: e.message }, status: :e.status
      else
        render json: { error: "Something went wrong" }, status: :internal_server_error
      end
    end

  end

  def show

    begin
      blob_data = BlobManager.retrieve_blob(params[:id], current_user)
      render json: blob_data

    rescue Exception => e
      if e.is_a?(BaseCustomError)
        render json: { error: e.message }, status: :e.status
      else
        render json: { error: "Something went wrong" }, status: :internal_server_error
      end
    end
  end

  private

  def blob_params
    params.permit(:id, :data)
  end
end
