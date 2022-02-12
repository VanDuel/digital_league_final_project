require 'open-uri'

class EventsController < ApplicationController
  has_scope :by_full_name
  has_scope :by_ticket_id
  has_scope :by_ticket_type
  has_scope :by_doc_number
  has_scope :by_act
  has_scope :by_result
  has_scope :by_terminal_type

  include EventsHelper

  def enter
    status, json = EnterService.new(params).call

    render json: json, status: status
  end

  def exit
    status, json = ExitService.new(params).call

    render json: json, status: status
  end

  def block
    ticket = get_ticket(params[:ticket_id])

    if ticket
      Action.create(
        ticket_id: params[:ticket_id],
        ticket_type: ticket[:ticket_type],
        event_id: ticket[:event_id],
        full_name: ticket[:full_name],
        doc_number: ticket[:doc_number],
        act: 2,
        result: true
      )

      render json: { message: 'билет заблокирован' }
    else
      render json: { message: 'билет не найден' }
    end
  end

  def journal
    actions = apply_scopes(Action)
      .by_event_id(params[:event_id])
      .order(created_at: :desc)

    render json: actions
  end
end
