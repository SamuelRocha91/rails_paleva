class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [
    :show, 
    :index, 
    :new, 
    :update, 
    :edit, 
    :destroy
  ]
  before_action :set_dish, only: [
    :edit, 
    :show, 
    :update, 
    :destroy, 
    :deactivate, 
    :activate,
    :offer
  ]
  
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
      redirect_to establishment_dishes_path, 
                    notice: 'Prato cadastrado com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @dish.update(dish_params)
      redirect_to establishment_dish_path(
        current_user.establishment,
         @dish
      ), notice: 'Prato atualizado com sucesso'
    end
  end

  def deactivate
    @dish.update(status: false)
    redirect_to establishment_dish_path(@dish.establishment, @dish)
  end

  def activate
    @dish.update(status: true)
    redirect_to establishment_dish_path(@dish.establishment, @dish)
  end

  def destroy
    if @dish.destroy
      redirect_to establishment_dishes_path(current_user.establishment), 
                   notice: 'Registro excluído com sucesso'
    end
  end

  def offer
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

  def set_dish
    @dish = Dish.find(params[:id])
  end
end