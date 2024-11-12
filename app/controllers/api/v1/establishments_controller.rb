class Api::V1::EstablishmentsController <  Api::V1::ApiController

  def list_orders
    establishment = Establishment.find_by(code: params[:code])
    if establishment.nil?
       raise ActiveRecord::RecordNotFound
    end
    orders = establishment.orders
    orders = orders.where(status: params[:status]) if params[:status]

    render status: 200, json: orders.as_json(include: :customer, except: [:updated_at, :id]) 
  end

end