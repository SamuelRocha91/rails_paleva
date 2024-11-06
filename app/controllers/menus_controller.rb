class MenusController < ApplicationController
  before_action :authenticate_user!

  def new
    @menu = Menu.new
  end
end