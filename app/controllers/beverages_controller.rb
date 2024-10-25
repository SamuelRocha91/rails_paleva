class BeveragesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = Beverage.new beverage_params
    if @beverage.save
      redirect_to establishment_beverages_path current_user.establishment.id,
                   notice: 'Bebida cadastrada com sucesso'
    else
      render :new
    end
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :is_alcoholic, :image)
  end
end