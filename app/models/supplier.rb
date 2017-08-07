class Supplier
  def self.store_hotel_prices(search_key, suppliers)
    targeted_suppliers = suppliers.blank? ? all_suppliers : suppliers
    targeted_suppliers.each do |supplier|
      SupplierSearchWorker.perform_async(search_key, supplier)
    end
  end

  def self.store_hotel_prices_one_supplier(search_key, supplier)
    RedisHelper.write_hash(search_key, supplier, get_hotel_price(supplier))
  end

  def self.get_hotel_price(supplier)
    supplier_url = SUPPLIER_LIST[supplier]
    conn = Faraday.new(supplier_url)
    resp = conn.get
    JSON.parse(resp.body)
  end

  def self.all_suppliers
    SUPPLIER_LIST.keys
  end
end
