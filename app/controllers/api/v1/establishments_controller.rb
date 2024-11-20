class Api::V1::EstablishmentsController <  Api::V1::ApiController
  before_action :set_establishment_and_order, only: [
    :show_order, 
    :accept_order, 
    :ready, 
    :cancel
  ]

  def list_orders
    establishment = Establishment.find_by(code: params[:code])
    if establishment.nil?
       raise ActiveRecord::RecordNotFound
    end
    orders = establishment.orders
    orders = orders.where(status: params[:status]) if params[:status] && 
                                                        params[:status] != ''

    render status: 200, json: orders.as_json(
      include: :customer, 
      except: [:updated_at, :id]
    ) 
  end

  def show_order
    order_json = @order.as_json(
      include: {
        customer: { only: [:name, :phone_number, :email] },
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

  def accept_order
    if @order.status != 'pending_kitchen_confirmation'
      message = { 
        message: "Status 'in_progress' não é válido para esse pedido"
      } 
      return render status: 400, json: message.to_json      
    end

    @order.in_preparation!

    render status: 200, json: @order.as_json(only: [:code, :status])
  end

  def ready
    if @order.status != 'in_preparation'
      message = { 
        message: "Status 'ready' não é válido para esse pedido" 
      } 
      return render status: 400, json: message.to_json      
    end

    @order.ready!

    render status: 200, json: @order.as_json(only: [:code, :status])
  end

  def cancel
    if @order.status != 'pending_kitchen_confirmation'
      message = { 
        message: "Status 'canceled' não é válido para esse pedido"
      }
      return render status: 400, json: message.to_json    
    end

    @order.canceled!

    render status: 200, json: @order.as_json(only: [:code, :status])

  end

  private

  def set_establishment_and_order
    @establishment = Establishment.find_by(code: params[:code])
    @order = Order.find_by(
      code: params[:order_code], 
      establishment: @establishment
    )
    if @order.nil?
       raise ActiveRecord::RecordNotFound
    end
  end

end