require 'eventmachine'
require 'bunny'
require 'json'
require './bin/ticket_control.rb'
class BookingTicketsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_booking_ticket, only: %i[ show edit update destroy ]
    # GET /booking_tickets or /booking_tickets.json
    def index
      if(params['event_id'] != nil)
        render json: {"Price": check_price(params['event_id'].to_i, params['t_type'])}
      else
        @booking_tickets = BookingTicket.all
        render json: @booking_tickets
      end
      #@booking_tickets = BookingTicket.all
      #render json: @booking_tickets
      # @booking_tickets.first
    end
  
    # GET /booking_tickets/1 or /booking_tickets/1.json
    def show
      @booking_ticket = BookingTicket.find_by_id(params: id)
      render json: @booking_ticket
    end
  
    def check_price(event_id, t_type)
        t_type_bd = TicketType.where(event_id: event_id, t_type: t_type)
        if t_type_bd == nil || t_type_bd == '' || t_type_bd == 0
          return "There is no such type of ticket"
        end
        t_init_num = t_type_bd.last.t_init_num
        t_init_price = t_type_bd.last.t_init_price
        t_now = t_type_bd.last.t_now
        if t_now == 0
            "no tickets"
        elsif t_init_num == t_now
            t_init_price.to_s
        elsif t_init_num < 10
            # ten_percent = t_init_num - t_now
            ten_percent = (t_init_num - t_now) * 10 / t_init_num
            price = t_init_price
            (1..ten_percent).each do
                price = price * 11 / 10
            end
            price.to_s
        else
            ten_percent =  9 - (t_now - 1) * 10 / t_init_num
            price = t_init_price
            (1..ten_percent).each do
                price = price * 11 / 10
            end
            price.to_s
        end
        
    end
    
    def bought_ticket_id
      @booking_ticket = BookingTicket.find(params['booking_id'])
      render json: @booking_ticket.ticket_id
    end

    def buy_ticket
      @booking_ticket = BookingTicket.find(params['booking_id'])
      if @booking_ticket.ticket_id != nil 
        render json: {"ticket id" => @booking_ticket.ticket_id}
      else
        if Time.now <= @booking_ticket.t_time + 300 && params['age'].to_i >= 13
          hash_request = {"event_id" => @booking_ticket.event_id, "t_type" => @booking_ticket.t_type, "t_price" => @booking_ticket.t_price}
          hash_request.merge({"FIO" => params['FIO'], "age" => params['age'], "doc_num" => params['doc_num'], "doc_type" => params['doc_type']})
          render json: {"Обновите страницу" => "Для получения id билета"}
          async_task(hash_request) #, params['booking_id'])
          # AnswerMachine.method(:return_answer(params['booking_id'])).call
        else
          destroy_without_render
          render json: {"В покупке отказано": "Бронь истекла или нарушено возрастное ограничение"} 
        end
      end
    end

    def destroy_without_render
      if(@booking_ticket != nil)
        TicketType.where(event_id: @booking_ticket.event_id.to_i, t_type: @booking_ticket.t_type).last.update(t_now: TicketType.where(event_id: @booking_ticket.event_id.to_i, t_type: @booking_ticket.t_type).last.t_now + 1)
        @booking_ticket.destroy
      end
    end

    def async_task(hash_request) #, booking_id)
      
        connection = Bunny.new('amqp://guest:guest@rabbitmq')
        connection.start
    
        channel = connection.create_channel
      
        exchange = channel.default_exchange
        queue_name = 'ticket_buy'
        exchange.publish(hash_request.to_json, routing_key: queue_name)

        #queue = channel.queue('waiting_for_ticket_id', auto_delete: true)

        #queue.subscribe do |_delivery_info, _metadata, payload|
        #  BookingTicket.find(booking_id).update(ticket_id: payload)
          connection.close 
        #end
    end
    # GET /booking_tickets/new
    def new
      begin
        tick_price = check_price(params['event_id'].to_i, params['t_type'])
        if tick_price == "no tickets"
          render json: {"Sorry" => "Sold out"}
        else
        @booking_ticket = BookingTicket.create(event_id: params['event_id'].to_i, t_type: params['t_type'], t_price: tick_price.to_i, t_time: Time.now)
        # страшнейший костыль, но я не обнаружил способа, как это сделать лучше
        TicketType.where(event_id: params['event_id'].to_i, t_type: params['t_type']).last.update(t_now: TicketType.where(event_id: params['event_id'].to_i, t_type: params['t_type']).last.t_now - 1)
        render json: {"booking_id" => @booking_ticket.id}
        end
      rescue 
        render json: {"Error" => "Can't book a ticket"}
      end
    end
  
    # GET /booking_tickets/1/edit
    def edit
    end
  
    # POST /booking_tickets or /booking_tickets.json
    #def create
      #@booking_ticket = BookingTicket.new(booking_ticket_params)
      
      #respond_to do |format|
      #  if @booking_ticket.save
      #    format.html { redirect_to @booking_ticket, notice: "BookingTicket was successfully created." }
     #     format.json { render :show, status: :created, location: @booking_ticket }
      #  else
       #   format.html { render :new, status: :unprocessable_entity }
       #   format.json { render json: @booking_ticket.errors, status: :unprocessable_entity }
     #   end
    #  end
   # end
  
    # PATCH/PUT /booking_tickets/1 or /booking_tickets/1.json
    def update
      respond_to do |format|
        if @booking_ticket.update(booking_ticket_params)
          format.html { redirect_to @booking_ticket, notice: "BookingTicket was successfully updated." }
          format.json { render :show, status: :ok, location: @booking_ticket }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @booking_ticket.errors, status: :unprocessable_entity }
        end
      end
    end
  


    # DELETE /booking_tickets/1 or /booking_tickets/1.json
    def destroy
      if(@booking_ticket != nil)
        TicketType.where(event_id: params['event_id'].to_i, t_type: params['t_type']).last.update(t_now: TicketType.where(event_id: params['event_id'].to_i, t_type: params['t_type']).last.t_now + 1)
        @booking_ticket.destroy
        respond_to do |format|
         format.html { redirect_to booking_tickets_url, notice: "Book was successfully destroyed." }
         format.json { head :no_content }
        end
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_booking_ticket
        @booking_ticket = BookingTicket.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def booking_ticket_params
        params.require(:booking_ticket).permit(:event_id, :t_type)
      end

end
