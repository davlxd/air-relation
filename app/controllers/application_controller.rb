class ApplicationController < ActionController::API
  before_action :extract_current_user

  private
  def extract_current_user
    render json: {message: 'Invalid Authentication'}, status: 401 and return unless UUID.validate(request.authorization)

    @current_user = User.find_by_air_auth_token(request.authorization)
    render json: {message: 'Illegal Authentication'}, status: 401 and return if @current_user.nil?

    request.headers['X-Air-User-Id'] = @current_user.id
  end
end
