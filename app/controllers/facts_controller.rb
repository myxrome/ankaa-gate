class FactsController < ActionController::Base
  include DeviceDataUploader

  def upload
    mapping = YAML.load_file "#{Rails.root}/config/mapping/statistic_keys.yml"
    status = perform(params[:data], mapping) ? 200 : 500
    render nothing: true, status: status
  end

private

  def event_id(val)
    Event.find_or_create_by!(tag: val) { |event|
      event.event_type = EventType.unknown
    }.id
  end

end