Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/relation/send-friend-request', to: 'friendship#send_friend_request'
  post '/relation/accept-friend-request', to: 'friendship#accept_friend_request'
  get '/relation/friend-requests', to: 'friendship#get_friend_requests'
  get '/relation/friends', to: 'friendship#get_friends'

  get '/relation/users/:id', to: 'user#get_user_detail' #TODO filter by friend or not
  get '/relation/users', to: 'user#search_users'

  get '/relation/conversations', to: 'conversation#get_conversations'
  get '/relation/conversations/:id', to: 'conversation#get_conversation_detail' #TODO Am I owner?; :id constraints
  get '/relation/conversation-id', to: 'conversation#get_conversation_id_by_friend_id' #TODO with params `by`
  delete '/relation/conversations/:conversation_id/members/:member_id', to: 'conversation#remove_conversation_member' #TODO must be owner; constraints
  delete '/relation/conversations/:id', to: 'conversation#opt_out_conversation' #TODO existence, owner replacement, not for dual; constraints
end
