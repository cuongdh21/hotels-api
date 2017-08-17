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

  def self.merge_prices(suppliers)
    suppliers_count = suppliers.count

    if suppliers_count == 1
      return suppliers.first
    elsif suppliers.count == 2
      merge_prices_two_suppliers(suppliers.first, suppliers.second)
    else
      half = (suppliers_count/2).round
      merge_prices([merge_prices(suppliers.first(half)), merge_prices(suppliers.last(suppliers_count - half))])
    end 
  end

  def self.merge_prices_two_suppliers(supplier1, supplier2)
    all_hotels = supplier1.keys | supplier2.keys
    all_hotels.inject({}) do |hotel_prices, hotel|
      if supplier1[hotel] && supplier2[hotel]
        hotel_prices[hotel] = supplier1[hotel][:price] < supplier2[hotel][:price] ? supplier1[hotel] : supplier2[hotel]
      else
        hotel_prices[hotel] = supplier1[hotel] || supplier2[hotel]
      end
      hotel_prices
    end 
  end
end
