require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '.fetch_hotel_prices, ' do
    let(:redis) { Redis.new }

    let(:search_key) { '31/08/2017:01/09/2017:Singapore:2' }

    let(:suplier1_hotels) { { hotel1: 1, hotel2: 2, hotel3: 3 } }
    let(:suplier2_hotels) { { hotel1: 1.5, hotel2: 0.5, hotel3: 2.5 } }

    before do
      allow(RedisHelper).to receive(:redis).with(no_args()).and_return(redis)
      RedisHelper.write_hash(search_key, 'supplier1', suplier1_hotels)
      RedisHelper.write_hash(search_key, 'supplier2', suplier2_hotels)
    end

    context 'suppliers are not specified, ' do
      it 'return list of hotels with lowest prices for all suppliers, ' do
        prices = Price.fetch_hotel_prices(search_key, [])

        expect(prices).to have_exactly(3).items

        expect(prices.first[:id]).to eq('hotel1')
        expect(prices.first[:price]).to eq(1)
        expect(prices.first[:supplier]).to eq('supplier1')

        expect(prices.second[:id]).to eq('hotel2')
        expect(prices.second[:price]).to eq(0.5)
        expect(prices.second[:supplier]).to eq('supplier2')

        expect(prices.third[:id]).to eq('hotel3')
        expect(prices.third[:price]).to eq(2.5)
        expect(prices.third[:supplier]).to eq('supplier2')
      end
    end

    context 'suppliers are specified, ' do
      it 'return list of hotels with lowest prices for those given suppliers, ' do
        prices = Price.fetch_hotel_prices(search_key, ['supplier1'])

        expect(prices).to have_exactly(3).items

        expect(prices.first[:id]).to eq('hotel1')
        expect(prices.first[:price]).to eq(1)
        expect(prices.first[:supplier]).to eq('supplier1')
      end
    end
  end
end
