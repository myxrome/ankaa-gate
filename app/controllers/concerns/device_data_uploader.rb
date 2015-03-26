module DeviceDataUploader extend ActiveSupport::Concern

  def perform(source, mapping)
    begin
      data = remap source, mapping
      update_data data
    rescue => e
      logger.error "Error: #{e.message}\n" + e.backtrace.join("\n")
      return false
    end
    true
  end

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

  def remap(source, mapping)
    source.map {|key, val|
      k = mapping[key]
      v = value(k, val, mapping)
      {k.to_s => respond_to?(k.to_sym, true) ? send(k.to_sym, v) : v}
    }.reduce(:merge)
  end

end