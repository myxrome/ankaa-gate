class FactsController < ActionController::Base
  include DeviceDataUploader

  def upload
    mapping = YAML.load_file "#{Rails.root}/config/mapping/statistic_keys.yml"
    render json: perform(params[:data], mapping)
  end

private

  def event_id(val)
    Event.find_or_create_by!(tag: val) { |event|
      event.event_type = EventType.unknown
    }.id
  end

end