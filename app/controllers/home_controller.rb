class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_establishment
  def index
    @menus = current_user.establishment.menus
                         .includes(menu_items: [:item])
                         .reject do |menu|
                           menu.valid_from.present? && (
                              menu.valid_from > Date.current || menu.valid_until < Date.current
                            )
                         end
  end
end
