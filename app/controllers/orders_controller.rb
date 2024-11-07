class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.new
    @order.build_customer
  end
end