class FriendshipController < ApplicationController
  def send_friend_request
    params.require(:to)
    render json: {message: 'Target user not exists'}, status: 404 and return unless User.exists?(params[:to])

    current_user = User.find_by_air_auth_token(request.authorization) # TODO: current_user & `?to=` existence is guaranteed by interceptor
    render json: {message: 'You cannot add yourself as a friend'}, status: 400 and return if current_user.id == params[:to]

    if Friendship.where(requester_id: params[:to], acceptor_id: current_user.id).exists?
      render json: {message: 'Friendship already exists'}, status: 409 and return
    end

    begin
      Friendship.create(requester_id: current_user.id, acceptor_id: params[:to], status: Friendship.statuses[:pending])
    rescue ActiveRecord::RecordNotUnique
      render json: {message: 'Friendship already exists'}, status: 409 and return
    end

    render status: 200
  end


  def accept_friend_request
    params.require(:from)
    current_user = User.find_by_air_auth_token(request.authorization) # TODO: current_user & `?to=` existence is guaranteed by interceptor

    friendship = Friendship.find_by(requester_id: params[:from], acceptor_id: current_user.id, status: Friendship.statuses[:pending])
    render json: {message: 'Record not found'}, status: 404 and return if friendship.nil?

    ActiveRecord::Base.transaction do
      friendship.update(status: Friendship.statuses[:accepted])

      request_user = User.find(params[:from])
      request_user.friends << current_user.id and request_user.save!
      current_user.friends << request_user.id and current_user.save!
    end
  end


  def get_friend_requests
    current_user = User.find_by_air_auth_token(request.authorization) # TODO: current_user & `?to=` existence is guaranteed by interceptor

    ret = Friendship.where(acceptor_id: current_user.id, status: Friendship.statuses[:pending]).pluck(:requester_id)
    render json: ret # TODO: more than ID
  end


  def get_friends
    current_user = User.find_by_air_auth_token(request.authorization) # TODO: current_user & `?to=` existence is guaranteed by interceptor
    render json: current_user.friends # TODO: more than ID
  end
end
