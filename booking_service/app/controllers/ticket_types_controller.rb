class TicketTypesController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_ticket_type, only: %i[ show edit update destroy ]

  def index
    @ticket_types = TicketType.all
    render json: @ticket_types
  end

  def show
    @ticket_type = TicketType.find_by_id(params: id)
    render json: @ticket_type
  end

  def self.new_ticket_type_for_e_controller(options)
    t_type_array = options['ticket_types']
    TicketType.transaction do
      t_type_array.each do |t|
        type = t[1..-2].split(', ')
        ticket_like_this = TicketType.where(event_id: options['event_id'].to_i, t_type: type[0])
        if ticket_like_this.last == nil 
          TicketType.create(t_type: type[0], t_init_num: type[1].to_i, t_init_price: type[2].to_i, event_id: options['event_id'].to_i, t_now: type[1].to_i)
        else
          ticket_like_this.last.t_init_price = type[2].to_i
          ticket_like_this.last.t_now = type[1].to_i - ticket_like_this.last.t_init_num + ticket_like_this.last.t_now
          ticket_like_this.last.t_init_num = type[1].to_i
        end
      end
      rescue
        raise ActiveRecord::Rollback
    end
  end

  def new
    t_type_array = params['t_type_array']
    TicketType.transaction do
      t_type_array.each do |t|
        type = t[1..-2].split(', ')
        ticket_like_this = TicketType.where(event_id: params['event_id'].to_i, t_type: type[0])
        if ticket_like_this.last == nil 
          TicketType.create(t_type: type[0], t_init_num: type[1].to_i, t_init_price: type[2].to_i, event_id: params['event_id'], t_now: type[1].to_i)
        else
          ticket_like_this.last.t_init_price = type[2].to_i
          ticket_like_this.last.t_now = type[1].to_i - ticket_like_this.last.t_init_num + ticket_like_this.last.t_now
          ticket_like_this.last.t_init_num = type[1].to_i
        end
      end
      status = { result: "Ok" }
    rescue
      status = { result: "Не удалось создать тип билета или новое количество билетов меньше кол-ва уже проданных билетов", params: params }
      raise ActiveRecord::Rollback
    end
    render json: status
  end


    private
        
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_type
        @ticket_type = TicketType.find(params[:id])
    end

    def ticket_type_params
        params.require(:ticket_type).permit(:event_id, :t_type, :t_init_num, :t_init_price)
        # or
        # params.require(:ticket_type).permit(:event_id, :t_type_array)
    end
end
