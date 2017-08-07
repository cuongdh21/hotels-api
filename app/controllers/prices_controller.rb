class PricesController < ApplicationController
  def index
    suppliers = formatted_params[:suppliers]
    Supplier.store_hotel_prices(search_key, suppliers)
    render json: Price.fetch_hotel_prices(search_key, suppliers)
  end
end
