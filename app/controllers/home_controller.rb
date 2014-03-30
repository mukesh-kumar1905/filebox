class HomeController < ApplicationController
  def index
  	 @assets = current_user.assets
  end
end
