class UsersController < ApplicationController
  before_action :authenticate_user!

  def home
    @cu=current_user
  end

end
