Rails.application.routes.draw do
  get 'events/:event_id/enter', to: 'events#enter'
  get 'events/:event_id/exit', to: 'events#exit'
  get 'events/:event_id/block', to: 'events#block'
  get 'events/:event_id/journal', to: 'events#journal'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
