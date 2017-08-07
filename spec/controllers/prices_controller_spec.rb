require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe 'POST #index, ' do
    let(:params) { { checkin: '31/08/2017', checkout: '01/09/2017', destination: 'Singapore', guests: 2, suppliers: ['supplier'] } }
    let(:hotel) { { id: 'hotel1', price: 1, supplier: 'supplier' } }

    before do
      allow(Supplier).to receive(:store_hotel_prices).with(anything(), anything()).and_return(nil)
      allow(Price).to receive(:fetch_hotel_prices).with('31/08/2017:01/09/2017:Singapore:2', ['supplier']).and_return([hotel])
    end

    subject { post :index, params: params }

    it 'return list of hotels, ' do
      expect(subject).to have_http_status(200)
      response_json = JSON.parse(subject.body)
      expect(response_json).to have_exactly(1).items
    end
  end
end
