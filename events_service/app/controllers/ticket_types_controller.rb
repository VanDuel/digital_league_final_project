class TicketTypesController < ApplicationController

  def new
    unless Event.where(id: params[:event_id]) == []
      ticket_type = TicketType.create(event_id: params[:event_id], ticket_type: params[:ticket_type], count: params[:count], init_price: params[:init_price])
      TicketTypeService.add_ticket_type(ticket_type)
      status = true
    end
  rescue
    status = false
    raise ActiveRecord::Rollback
  ensure
    render json: status
  end

  def index
    ticket_types = TicketType.all
    render json: ticket_types, each_serializer: TicketTypeSerializer
  end

  def update
    TicketType.transaction do
    ticket_type = TicketType.where(event_id: params[:event_id], t_type: params[:t_type]).update(init_price: params[:new_price].to_i) unless params[:new_price].blank?
    ticket_type = TicketType.where(event_id: params[:event_id], t_type: params[:t_type]).update(t_type: params[:new_type]) unless params[:new_type].blank?
    begin
      # Отправляю изменения в booking_service
      # EventService.update_types(ticket_type)
      render json: ticket_type
      rescue
        render json: {result: "Ошибка соединения"}
        raise ActiveRecord::Rollback
    end
    rescue
      render json: {result: "Проверьте правильность переданных параметров", params: params}
      raise ActiveRecord::Rollback
    end
  end
end