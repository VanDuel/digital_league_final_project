require 'open-uri'

class EventService
  include EventsHelper

  def initialize(params)
    @params = params
  end

  def call
    raise NotImplementedError
  end

  private

  def get_last_action
    Action
      .successful
      .where(event_id: @params[:event_id])
      .where(ticket_id: @params[:ticket_id])
      .order(created_at: :desc)
      .first
  end

  def check_category(category)
    category == 'vip' || category == @params[:terminal_type]
  end

  def check_action(action)
    raise NotImplementedError
  end

  def create_action(action, n, result = true)
    Action.create(
      ticket_id: action.ticket_id,
      ticket_type: action.ticket_type,
      event_id: action.event_id,
      terminal_type: @params[:terminal_type],
      full_name: action.full_name,
      doc_number: action.doc_number,
      act: n,
      result: result
    )
  end

  def report(status, message)
    [
      status,
      { message: message }
    ]
  end
end
