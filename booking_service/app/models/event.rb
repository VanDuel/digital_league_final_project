class Event < ApplicationRecord
    has_many :booking_tickets
    has_many :ticket_types  
end
