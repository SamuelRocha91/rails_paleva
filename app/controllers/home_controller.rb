class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_establishment
  def index
    @menus = current_user.establishment.menus.includes(menu_items: [:item])
  end
end