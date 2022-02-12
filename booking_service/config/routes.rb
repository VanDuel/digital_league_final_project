Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :events
  # resources :ticket_types
  # resources :booking_tickets do
  #   collection do
  #     get 'buy_ticket'
  #   end
  # end

  get 'events', to: 'events#index'
  get 'events/new', to: 'events#new'
  get 'events/:id', to: 'events#show'
  get 'events/update', to: 'events#update'
  get 'ticket_type_list', to: 'ticket_types#index'
  # get 'update_ticket_price', to: ''
  
  get 'booking', to: 'booking_tickets#new'
  get 'booking_tickets_list', to: 'booking_tickets#index'
  get 'booking_delete/:id', to: 'booking#destroy'
end
