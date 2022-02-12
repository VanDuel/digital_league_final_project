class Event < ApplicationRecord
  has_many :bought_tickets
  has_many :ticket_types
end
