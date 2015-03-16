class ExternalMessagesController < ActionController::Base

  def upload
    status = perform(params) ? 200 : 500
    render nothing: true, status: status
  end

  private

  def perform(params)
    begin
      message = ExternalMessage.create!(source: params[:type], message: params[:data].to_json)
      send(params[:type], message) if respond_to?(params[:type].to_sym, true)
    rescue => e
      return false
    end
    true
  end

  def gdeslon(message)
    data = JSON.parse message.message
    event = Event.find_by(tag: 'VALUE_CONVERSION')
    fact = message.build_fact(event: event, external_context: data['sub_id'])
    fact.fact_details.build(order: 1, happened_at: data['action_time'])
    fact.save!
  end

end