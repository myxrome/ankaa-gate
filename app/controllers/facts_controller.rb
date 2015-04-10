class FactsController < ActionController::Base
  include DeviceDataUploader

protected

  def mapping_path
    "#{Rails.root}/config/mapping/statistic_keys.yml"
  end

private

  def event_id(val)
    Event.find_or_create_by!(tag: val) { |event|
      event.event_type = EventType.unknown
    }.id
  end

end