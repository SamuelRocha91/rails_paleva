class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:in_preparation, :ready]
  
  def index
    @orders = Order.where(establishment: current_user.establishment)
  end
  def new
    @order = Order.new
    @order.build_customer
  end

  def create
    @order = Order.new(order_params)
    @order.establishment_id = current_user.establishment.id
    session_items = session[:order_items] || []

    if @order.save
      session_items.each do |item|
        portion = Offer.find(item["portion_id"])
        OrderItem.create!(offer: portion, note: item["observation"], order: @order)
      end
      session[:order_items] = nil
      redirect_to root_path, 
                    notice: 'Pedido realizado com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new_offer
  end

  def new_item
    @portion = Offer.find(params[:portion_id])
  end

  def add_item
    @portion = Offer.find(params[:portion_id]) 
    session[:order_items] ||= []
    session[:order_items] << {
      portion_id: @portion.id,
      observation: params[:observation]
    }
    
    redirect_to preview_order_path
  end

  def preview_order
    @order_items = session[:order_items] || []
    @portions = []
    @total = 0
    @order_items.each do |item|
      portion = Offer.find(item["portion_id"]) 
      @portions << { portion: portion, observation: item["observation"] }
      @total += portion.price
    end
  end

  def in_preparation
    if @order.in_preparation!
      redirect_to orders_path, notice: 'Status do Pedido atualizado com sucesso'
    end
  end

  def ready
    if @order.ready!
      redirect_to orders_path, notice: 'Status do Pedido atualizado com sucesso'
    end
  end

  private

  def order_params
    params.require(:order).permit(
      customer_attributes: 
        [:name, :cpf, :email, :phone_number]
    )
  end

  def set_order
    @order = Order.find(params[:id])
  end
end