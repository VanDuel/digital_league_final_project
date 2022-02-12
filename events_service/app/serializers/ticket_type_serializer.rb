class TicketTypeSerializer < ActiveModel::Serializer
  attributes :id, :ticket_type, :count, :init_price
  def ticket_type
    object.ticket_type
  end

  def count
    object.count
  end

  def init_price
    object.init_price
  end
end