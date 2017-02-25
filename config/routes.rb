Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/relation/send-friend-request', to: 'friendship#send_friend_request'
  post '/relation/accept-friend-request', to: 'friendship#accept_friend_request'
  get '/relation/friend-requests', to: 'friendship#get_friend_requests'
  get '/relation/friends', to: 'friendship#get_friends'
end
