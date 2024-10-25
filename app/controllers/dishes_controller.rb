class DishesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end
  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new(dish_params)
    @dish.establishment = Establishment.find(params[:establishment_id])
    if @dish.save
      redirect_to establishment_dishes_path, notice: 'Prato cadastrado com sucesso'
    else
      render :new
    end
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :image, :calories)
  end
end