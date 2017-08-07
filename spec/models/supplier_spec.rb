require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '.store_hotel_prices_one_supplier, ' do
    let(:redis) { Redis.new }
    let(:search_key) { '31/08/2017:01/09/2017:Singapore:2' }

    before do
      allow(RedisHelper).to receive(:redis).with(no_args()).and_return(redis)
    end

    it 'store list of hotels for the supplier' do
      Supplier.store_hotel_prices_one_supplier(search_key, 'supplier1')
      Supplier.store_hotel_prices_one_supplier(search_key, 'supplier2')
      Supplier.store_hotel_prices_one_supplier(search_key, 'supplier3')

      hotel_prices = RedisHelper.read_all_hash(search_key)
      expect(hotel_prices['supplier1']).not_to be_empty
      expect(hotel_prices['supplier2']).not_to be_empty
      expect(hotel_prices['supplier3']).not_to be_empty
    end
  end

  describe '.all_suppliers, ' do
    it 'return all suppliers in the config file' do
      expect(Supplier.all_suppliers).to have_exactly(3).items
    end
  end
end
