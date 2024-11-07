class MenusController < ApplicationController
  before_action :authenticate_user!

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(establishment: current_user.establishment, name: menu_params[:name])
    if @menu.save
      redirect_to @menu, notice: 'Cardápio cadastrado com sucesso'
    else
      render :new
    end
  end

  def show
    @menu = Menu.find(params[:id])
  end

  private

  def menu_params
    params.require(:menu).permit(:name)
  end
end