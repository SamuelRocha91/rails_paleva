class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :employee?, only: [:create, :new] 

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.establishment = current_user.establishment
    if @menu.save
      redirect_to @menu, notice: 'Cardápio cadastrado com sucesso'
    else
      p 'aqui?'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @menu = Menu.find(params[:id])
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :valid_from, :valid_until)
  end
end