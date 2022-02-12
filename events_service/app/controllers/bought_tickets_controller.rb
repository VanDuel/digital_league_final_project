class BoughtTicketsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    render json: BoughtTicket.all, each_serializer: BoughtTicketSerializer
  end

  def check
    boughtTicket = BoughtTicket.where("id = #{params[:ticket_id]}")
    render json: boughtTicket
    rescue ActiveRecord::RecordNotFound => _e
      render json: { result: false }
  end

  def new
    unless BoughtTicket.find_by_booking_id(params[:booking_id].to_i)
      BoughtTicket.create(
          event_id: params[:event_id].to_i,
          booking_id: params[:booking_id].to_i,
          ticket_FIO: params[:ticket_FIO],
          ticket_age: params[:ticket_age].to_i,
          ticket_price: params[:ticket_price].to_i,
          ticket_type: params[:ticket_type],
          doc_num: params[:doc_num].to_i,
          doc_type: params[:doc_type]
      )
      PublishService.return_id(BoughtTicket.last.id)
      render json: BoughtTicket.last.id

    else
      render json: { result: false }
    end
  end
end