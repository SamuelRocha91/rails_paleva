class DishesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end
  def new
    @dish = Dish.new
  end
end