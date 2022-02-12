class BoughtTicketSerializer < ActiveModel::Serializer
  attributes :id, :booking_id, :ticket_FIO, :ticket_age, :ticket_price, :ticket_type, :doc_num, :doc_type, :event_id

  def event_id
    object.event_id
  end

  def booking_id
    object.booking_id
  end

  def ticket_FIO
    object.ticket_FIO
  end

  def ticket_age
    object.ticket_age
  end

  def ticket_price
    object.ticket_price
  end

  def ticket_type
    object.ticket_type
  end

  def doc_num
    object.doc_num
  end

  def doc_type
    object.doc_type
  end
end