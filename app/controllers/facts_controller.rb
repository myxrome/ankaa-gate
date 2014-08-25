class FactsController < ActionController::Base

  def upload
    begin
      mapping = YAML.load_file "#{Rails.root}/config/keys.yml"
      data = remap params[:data], mapping
      update_data data
    rescue Exception => e
      render json: {error: e.message}
    end
    render json: ''
  end

private

  def update_data(data)
    device = Device.find_or_create_by(udid: data['udid'])
    device.update data
  end

  def value(key, val, mapping)
    if val.is_a?(Array)
      val.map { |item|
        {Random.rand(10000).to_s => value(key, item, mapping)}
      }.reduce(:merge)
    else if val.is_a?(Hash)
           remap(val, mapping[key])
         else
           val
         end
    end
  end

  def event_id(val)
    Event.find_by(tag: val).id
  end

  def remap(source, mapping)
    source.map {|key, val|
      k = mapping[key]
      v = value(k, val, mapping)
      {k.to_s => respond_to?(k.to_sym, true) ? send(k.to_sym, v) : v}
    }.reduce(:merge)
  end

end