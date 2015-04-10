module DeviceDataUploader extend ActiveSupport::Concern
require 'base64'

  def get_upload
    begin
      base = Base64.urlsafe_decode64 params[:d]
      source = Zlib::GzipReader.new(StringIO.new(base)).read
      data = JSON.parse source
    rescue => e
      logger.error "Error: #{e.message}\n" + e.backtrace.join("\n")
      ErrorMailer.error_email(e).deliver
      render nothing: true, status: 500
    end
    upload data['data']
  end

  def post_upload
    upload params[:data]
  end

  def perform(source, mapping)
    begin
      data = remap source, mapping
      update_data data
    rescue => e
      logger.error "Error: #{e.message}\n" + e.backtrace.join("\n")
      ErrorMailer.error_email(e).deliver
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
      if k
        v = value(k, val, mapping)
        {k.to_s => respond_to?(k.to_sym, true) ? send(k.to_sym, v) : v}
      end
    }.reduce(:merge)
  end

protected
  def mapping_path
    ''
  end

private

  def upload(data)
    mapping = YAML.load_file mapping_path
    status = perform(data, mapping) ? 200 : 500
    render nothing: true, status: status
  end

end