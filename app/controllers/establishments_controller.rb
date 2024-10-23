class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  def new
    @establishment = Establishment.new
    @establishment.operating_hours.build
  end
end