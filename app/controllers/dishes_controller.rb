class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:show, :index, :new]
  
  def index
    @dishes = current_user.establishment.dishes
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

  def show
    @dish = Dish.find(params[:id])
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :image, :calories)
  end

  def check_user
    @establishment = Establishment.find(params[:establishment_id])
    if @establishment.user != current_user
      redirect_to root_path, notice: 'Você não possui acesso a esse prato'
    end
  end
end