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

  def show_order
    establishment = Establishment.find_by(code: params[:code])
    order = Order.find_by(code: params[:order_code], establishment: establishment)

    if order.nil?
       raise ActiveRecord::RecordNotFound
    end

    order_json = order.as_json(
      include: {
        customer: { only: :name },
        order_items: {
          only: [:note],
          include: {
            offer: { 
              only: [:price, :name],
              include: {
                format: { only: :name },
                item: { only: :name }
              }
            },
          }
        }
      },
      except: [:updated_at, :id]
    )

    render status: 200, json: order_json


  end

end