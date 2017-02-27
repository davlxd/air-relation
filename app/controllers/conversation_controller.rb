class ConversationController < ApplicationController
  def get_conversation_id_by_friend_id
    params.require(:by)
    render json: {message: 'Invalid friend_id'}, status: 400 and return unless UUID.validate(params[:by])
    render json: {message: 'Invalid friend_id'}, status: 404 and return unless User.exists?(params[:by])
    render json: {message: 'You cannot talk to yourself'}, status: 409 and return if @current_user.id == params[:by]

    dual_id = (uuid_hex(@current_user.id) ^ uuid_hex(params[:by])).to_s(16)
    conversation = Conversation.find_by_dual_id(dual_id)

    if conversation.nil?
      ActiveRecord::Base.transaction do
        conversation = Conversation.create(dual_id: dual_id)
        conversation.conversation_memberships.create(user_id: @current_user.id)
        conversation.conversation_memberships.create(user_id: params[:by])
      end
    end
    render json: {conversation_id: conversation.id}
  end


  def get_conversations
    render json: ConversationMembership.where(user_id: @current_user.id).pluck(:conversation_id) # TODO: more than ID; TODO filter by clip records
  end


  private
  def uuid_hex(uuid_str)
    uuid_str.gsub('-', '').to_i(16)
  end
end
