class EventsController < ApplicationController
  def index
    if params['event_date'].blank?
      @events = Event.all
    else
      @events = Event.where(event_date: params['event_date'])
    end
    render json: @events, each_serializer: EventSerializer
  end

  def new
    status = { result: true, message: 'OK' }
    Event.transaction do
      event = Event.create(event_name: params['event_name'], event_date: params['event_date'], general_feels: 0)
      types = []
      begin
        params[:ticket_types].each do |t|
          type = t[1..-2].split(', ')
          types << TicketType.create(ticket_type: type[0], count: type[1].to_i, init_price: type[2].to_i, event_id: Event.last.id)
        end
      rescue
        status[:result] = false
        status[:message] = 'Проверьте правильность переданных параметров'
        status[:params] = params
        raise ActiveRecord::Rollback
      end
      begin
        # Отправляю созданный ивент в booking_service
        respond = EventService.add_event(event)
      rescue
        status[:result] = false
        status[:message] = 'Ошибка соединения'
        status[:respond] = respond
        raise ActiveRecord::Rollback
      end
    end
    render json: status
  end
end
