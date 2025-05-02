class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index

  end

  def login
    username = params.expect(:username)
    password = params.expect(:password)

    if password == ENV.fetch('THE_PASSWORD')
      @user = User.first_or_create!(username:)
      return redirect_to '/dashboard'
    end

    redirect_back fallback_location: 'HomeController#index'
  end

  def logout
    redirect_to '/'
  end

  def dashboard
    params.permit(:edit, :sell, :owned)
    @user = User.where(username: 'mecu').first!
    @history = @user.histories

    if params[:owned].present?
      @history = @history.filter do |h|
        h[:sell_date].nil?
      end
    end
  end

  def about

  end
end
