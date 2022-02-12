class EventsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.all
    render json: @events
  end

  def show
    @event = Event.find_by_id(params[:id])
    render json: @event
  end

  def new(options = {})
    if (options == {})
      @event = Event.create(id: params['event_id'],event_name: params['event_name'], event_date: params['event_date'])
      hash_request = {"event_id" => @event.id, "ticket_types" => params['ticket_types']}
      TicketTypesController.new_ticket_type_for_e_controller(hash_request)
    else
      @event = Event.create(event_name: options['event_name'], event_date: options['event_date'])
      TicketTypesController.new_ticket_type_for_e_controller({"event_id" => @event.id, "ticket_types" => options['ticket_types']})
    end
    render json: @event
  end

  def update
    event = Event.where(id: params['event_id'])
    event.update(event_name: params['event_name']) unless params['event_name'].blank?
    event.update(event_date: params['event_date']) unless params['event_date'].blank?
    status = true
  rescue
    status = false
  ensure
    render json: { status: status, result: event }
  end

  def new_for_crud_create(options)
    @event = Event.create(event_name: options['event_name'], event_date: options['event_date'].to_date)
    TicketTypesController.new_ticket_type_for_e_controller({"event_id" => @event.id, "tickettypes" => options['t_type_array']})
  end

    # POST /events or /events.json
  def create
   # Event.create(event_name: "test")
    event_list = params['events']
    event_list.each do |el|
      new_for_crud_create(el)
            # @event.save
    end
    render json: Event.all
        #@event = Event.new

        #respond_to do |format|
        #    if @event.save
        #        format.html { redirect_to @event, notice: "Event was successfully created." }
        #        format.json { render :show, status: :created, location: @event }
        #    else
        #        format.html { render :new, status: :unprocessable_entity }
        #        format.json { render json: @event.errors, status: :unprocessable_entity }
        #    end
        #endevent_id
  end

    # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
        #respond_to do |format|
        #    format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
        #    format.json { head :no_content }
        #end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:event_name, :event_date, :t_type_array)
  end
end
