class Price
  def self.fetch_hotel_prices(search_key, suppliers)
    targeted_suppliers = suppliers.blank? ? Supplier.all_suppliers : suppliers

    hotels_with_prices = {}
    RedisHelper.read_all_hash(search_key).each do |supplier, hotels|
      next if targeted_suppliers.exclude?(supplier)
      JSON.parse(hotels).each do |hotel_id, price|
        hotel_min_price = hotels_with_prices[hotel_id].present? ? hotels_with_prices[hotel_id][:price] : Float::INFINITY
        hotels_with_prices[hotel_id] = { id: hotel_id, price: price, supplier: supplier } if price < hotel_min_price
      end
    end

    hotels_with_prices.values
  end
end
