require 'uri'
require 'net/http'

class HistoryController < ApplicationController
  protect_from_forgery with: :null_session

  def buy
    params.permit(:username, :ticker, :qty, :price, :date)
    user = User.where(username: params['username']).first!
    ticker = params[:ticker]
    History.create({ user:, ticker:, qty: params[:qty], price: params[:price], buy_date: params[:date] })
    details = ticker_details(ticker)['chart']['result'][0]['meta']

    render 'search/details', locals: {ticker:, details:, user:, buy: true}
  end

  def sell
    params.permit(:history_id, :sell_price, :sell_date)
    History.find(params[:history_id]).update(sell_price: params[:sell_price], sell_date: params[:sell_date])

    @user = User.where(username: 'mecu').first!
    @history = @user.histories

    render 'home/dashboard', locals: {sell: true}
  end

  def edit
    permitted = params.permit(:history_id, :buy_date, :qty, :price, :sell_price, :sell_date)
    History.find(params[:history_id]).update(permitted.except(:history_id))

    @user = User.where(username: 'mecu').first!
    @history = @user.histories

    render 'home/dashboard', locals: {edit: true}
  end

  def edit_form
    params.permit(:history_id)
    @history_id = params[:history_id]

    render partial: 'partials/edit_form'
  end

  def delete
    params.permit(:history_id)
    History.find(params[:history_id]).delete

    @user = User.where(username: 'mecu').first!
    @history = @user.histories

    render 'home/dashboard', locals: {delete: true}
  end

  private

  def ticker_details(ticker)
    uri = URI(YAHOO_TICKER_URL + ticker.upcase)
    results = Net::HTTP.get_response(uri, { 'User-Agent': 'Mozilla/5.0' }).body
    JSON.parse(results)
  end
end
