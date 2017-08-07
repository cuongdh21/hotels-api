Rails.application.routes.draw do
  scope 'hotels' do
    get 'heartbeat', to: 'heartbeat#index'
    post '/prices', to: 'prices#index'
  end
end
