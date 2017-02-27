Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/relation/users/:target_id/friend-requests', to: 'friendship#send_friend_request'
  post '/relation/friends/:requester_id', to: 'friendship#accept_friend_request'
  get '/relation/friend-requests', to: 'friendship#get_friend_requests'
  get '/relation/friends', to: 'friendship#get_friends'

  get '/relation/users/:id', to: 'user#get_user_detail' #TODO filter by friend or not
  get '/relation/users', to: 'user#search_users'

  get '/relation/conversations', to: 'conversation#get_conversations'
  get '/relation/conversations/:id', to: 'conversation#get_conversation_detail' #TODO Am I owner?; :id constraints

  get '/relation/conversation-id', to: 'conversation#get_conversation_id_by_friend_id'

  post '/relation/conversations/:conversation_id/members/:member_id', to: 'conversation#add_conversation_member' #TODO :id constraints; generate owner
  delete '/relation/conversations/:conversation_id/members/:member_id', to: 'conversation#remove_conversation_member' #TODO must be owner; :id constraints

  delete '/relation/conversations/:id', to: 'conversation#opt_out_conversation' #TODO existence, owner replacement, not for dual; constraints
end
