class Api::V1::EstablishmentsController < ActionController::API
  def list_orders
    orders = Establishment.find_by(code: params[:code]).orders
    orders = orders.where(status: params[:status]) if params[:status]
    render status: 200, json: orders.as_json(include: :customer, except: [:updated_at, :id]) 
  end
end