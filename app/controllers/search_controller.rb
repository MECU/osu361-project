require 'uri'
require 'net/http'

class SearchController < ApplicationController
  protect_from_forgery with: :null_session

  def index

  end

  def ticker
    ticker = params.require(:ticker)
    results = search_ticker(ticker)['quotes']
    render 'search/index', locals: { ticker:, results: }
  end

  def details
    ticker = params.require(:ticker)
    details = ticker_details(ticker)['chart']['result'][0]['meta']
    user = User.where(username: 'mecu').first!
    # news = search_ticker(ticker)['news']
    render 'search/details', locals: { ticker:, details:, user: }
  end

  private

  def search_ticker(ticker)
    uri = URI(YAHOO_SEARCH_URL + ticker.upcase)
    results = Net::HTTP.get_response(uri, { 'User-Agent': 'Mozilla/5.0' }).body
    JSON.parse(results)
  end

  def ticker_details(ticker)
    uri = URI(YAHOO_TICKER_URL + ticker.upcase)
    results = Net::HTTP.get_response(uri, { 'User-Agent': 'Mozilla/5.0' }).body
    JSON.parse(results)
  end
end
