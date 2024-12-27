class Api::V1::EstablishmentsController < Api::V1::ApiController
  before_action :set_establishment_and_order, only: %i[
    show_order
    accept_order
    ready
    cancel
  ]

  def list_orders
    establishment = Establishment.find_by(code: params[:code])
    raise ActiveRecord::RecordNotFound if establishment.nil?

    orders = establishment.orders
    orders = orders.where(status: params[:status]) if params[:status] && params[:status] != ''
    render status: :ok, json: orders.as_json(
      include: :customer,
      except: %i[updated_at id]
    )
  end

  def show_order
    order_json = @order.as_json(
      include: { customer: { only: %i[name phone_number email] }, order_items: { only: [:note],
                                                                                 include: { offer: {
                                                                                   only: %i[price name],
                                                                                   include: { format: { only: :name },
                                                                                              item: { only: :name } }
                                                                                 } } } },
      except: %i[updated_at id]
    )
    render status: :ok, json: order_json
  end

  def accept_order
    if @order.status != 'pending_kitchen_confirmation'
      message = {
        message: "Status 'in_progress' não é válido para esse pedido"
      }
      return render status: :bad_request, json: message.to_json
    end

    @order.in_preparation!

    render status: :ok, json: @order.as_json(only: %i[code status])
  end

  def ready
    if @order.status != 'in_preparation'
      message = {
        message: "Status 'ready' não é válido para esse pedido"
      }
      return render status: :bad_request, json: message.to_json
    end

    @order.ready!

    render status: :ok, json: @order.as_json(only: %i[code status])
  end

  def cancel
    if @order.status != 'pending_kitchen_confirmation'
      message = { message: "Status 'canceled' não é válido para esse pedido" }
      return render status: :bad_request, json: message.to_json
    end
    if !params[:justification]
      render status: :bad_request, json: { error: 'Cancelamento deve ser justificado' }
    else
      justify_and_cancel
      render status: :ok, json: @order.as_json(only: %i[code status])
    end
  end

  private

  def set_establishment_and_order
    @establishment = Establishment.find_by(code: params[:code])
    @order = Order.find_by(
      code: params[:order_code],
      establishment: @establishment
    )
    return unless @order.nil?

    raise ActiveRecord::RecordNotFound
  end

  def justify_and_cancel
    justification = Cancellation.new(justification: params[:justification])
    @order.cancellation = justification
    @order.canceled!
  end
end
