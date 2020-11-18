Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'webhook/twilio', to: 'webhook/twilio#create'
  post 'webhook/twilio/status', to: 'webhook/twilio#status_update'
  resources :messages, only: [:index, :create] do
    post '/send_template', to: 'messages#send_template', on: :collection
  end
end
