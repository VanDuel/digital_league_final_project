class EventSerializer < ActiveModel::Serializer
  attributes :id, :event_name, :event_date
  has_many :ticket_types, serializer: TicketTypeSerializer
  def event_name
    object.event_name
  end

  def event_date
    object.event_date
  end
end
