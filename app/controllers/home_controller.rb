class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_establishment
  def index
  end
end