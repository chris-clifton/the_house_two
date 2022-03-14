class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:slug])
  end

  def index
  end
end
