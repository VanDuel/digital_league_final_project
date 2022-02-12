class Action < ApplicationRecord
  enum act: %w[exit enter block]

  scope :by_event_id, ->(event_id) { where(event_id: event_id) }
  scope :by_full_name, ->(full_name) { where(full_name: full_name) }
  scope :by_ticket_id, ->(ticket_id) { where(ticket_id: ticket_id) }
  scope :by_ticket_type, ->(ticket_type) { where(ticket_type: ticket_type) }
  scope :by_doc_number, ->(doc_number) { where(doc_number: doc_number) }
  scope :by_act, ->(act) { where(act: act) }
  scope :by_result, ->(result) { where(result: result) }
  scope :successful, -> { where(result: true) }
  scope :by_terminal_type, ->(terminal_type) { where(terminal_type: terminal_type) }
end
