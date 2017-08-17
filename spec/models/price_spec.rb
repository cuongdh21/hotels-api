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

  describe '.merge_prices' do
    let(:expedia_result) { {
      hot1: { price: 100, key: 'ex-1', additional: 'no children' },
      hot2: { price: 200, key: 'ex-2' },
      hot3: { price: 300, key: 'ex-3' },
      hot4: { price: 400, key: 'ex-4' }
    } }

    let(:agoda_result)  { {
      hot1: { price: 110, key: 'ag-1'},
      hot4: { price: 350, key: 'ag-4'}
    } }

    let(:booking_result) { {
      hot2: { price: 190, key: 'bk-2' },
      hot3: { price: 300, key: 'bk-3' },
      hot4: { price: 320, key: 'bk-4' }
    } }

    let(:orbitz_result) { {
      hot4: { price: 290, key: 'or-4' },
      hot5: { price: 420, key: 'or-5' }
    } }

    it "works" do
      result = Price.merge_prices([expedia_result, agoda_result, booking_result, orbitz_result])
      expect(result[:hot1]).to eq(expedia_result[:hot1])
      expect(result[:hot2]).to eq(booking_result[:hot2])
      expect(result[:hot3]).to eq(booking_result[:hot3])
      expect(result[:hot4]).to eq(orbitz_result[:hot4])
      expect(result[:hot5]).to eq(orbitz_result[:hot5])

      result = Price.merge_prices([expedia_result, agoda_result])
      expect(result[:hot1]).to eq(expedia_result[:hot1])
      expect(result[:hot2]).to eq(expedia_result[:hot2])
      expect(result[:hot3]).to eq(expedia_result[:hot3])
      expect(result[:hot4]).to eq(agoda_result[:hot4])

      result = Price.merge_prices([expedia_result])
      expect(result).to eq(expedia_result)
    end
  end
end
