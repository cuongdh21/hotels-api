class ApplicationController < ActionController::API
  private

  def search_key
    "#{formatted_params[:checkin]}:#{formatted_params[:checkout]}:#{formatted_params[:destination]}:#{formatted_params[:guests]}"
  end

  def formatted_params
    @formatted_params ||= ActionController::Parameters.new(params.to_unsafe_hash.deep_transform_keys { |key| key.to_s.underscore.to_sym })
  end
end
