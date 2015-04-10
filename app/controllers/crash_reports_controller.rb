class CrashReportsController < ActionController::Base
  include DeviceDataUploader

protected
  def mapping_path
    "#{Rails.root}/config/mapping/crash_report_keys.yml"
  end

end
