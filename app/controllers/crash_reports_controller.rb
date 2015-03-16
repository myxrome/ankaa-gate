class CrashReportsController < ApplicationController

  def upload
    def upload
      mapping = YAML.load_file "#{Rails.root}/config/mapping/crash_report_keys.yml"
      render json: perform(params[:data], mapping)
    end
  end

end
