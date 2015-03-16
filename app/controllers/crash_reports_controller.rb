class CrashReportsController < ActionController::Base
  include DeviceDataUploader

  def upload
    mapping = YAML.load_file "#{Rails.root}/config/mapping/crash_report_keys.yml"
    status = perform(params[:data], mapping) ? 200 : 500
    render nothing: true, status: status
  end

end
