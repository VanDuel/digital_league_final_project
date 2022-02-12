Rails.application.routes.draw do
  get 'ticket_types/update', to: 'ticket_types#update'
  get 'events', to: 'events#index'
  get 'events/new', to: 'events#new'
  get 'buy_ticket', to: 'bought_tickets#new'
  get 'check_ticket', to: 'bought_tickets#check'
end
