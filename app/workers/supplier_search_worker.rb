class SupplierSearchWorker
  include Sidekiq::Worker

  def perform(search_key, supplier)
    Supplier.store_hotel_prices_one_supplier(search_key, supplier)
  end
end
