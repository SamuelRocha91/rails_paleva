class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404

  private

  def return_500
    render status: :internal_server_error
  end

  def return_404
    render status: :not_found
  end
end
