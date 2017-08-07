class HeartbeatController < ActionController::API
  def index
    render plain: 'OK'
  end
end
