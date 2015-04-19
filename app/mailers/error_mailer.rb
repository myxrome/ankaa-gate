class ErrorMailer < ActionMailer::Base
  default from: 'robot@whiteboxteam.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.miner_mailer.result_email.subject
  #
  def error_email(error, source)
    @error = error
    @source = source
    mail subject: "[#{ENV['INSTALLATION_TYPE']}][Statistic Upload Error]", to: 'alert@whiteboxteam.com'
  end

end
