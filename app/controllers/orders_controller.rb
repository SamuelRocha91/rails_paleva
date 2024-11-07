class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.new
    @order.build_customer
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, 
                    notice: 'Pedido aberto com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(
      customer_attributes: 
        [:name, :cpf, :email, :phone_number]
    )
  end
end