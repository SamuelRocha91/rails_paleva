class MenuItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @menu = Menu.find(params[:menu_id])
    @menu_item = MenuItem.new
    if params[:type] == 'dish'
      @type = 'Dish'
      @items = current_user.establishment.dishes
    else
      @type = 'Beverage'
      @items = current_user.establishment.beverages
    end
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      flash[:notice] = 'Item adicionado com sucesso'
      redirect_to menu_path params[:menu_id]
    else
      render :new
    end
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:item_type, :item_id, :menu_id)
  end
end