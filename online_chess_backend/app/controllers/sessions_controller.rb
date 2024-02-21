class SessionsController < ApplicationController
  # loginではjwt検証をしない
  skip_before_action :_verify_token, only: [:new]

  def new
    # ログイン
    user = User.find_by(email: params['email'])
    unless user && user.authenticate(params[:password])
      render json: { error: 'Invalid user information' }, status: :bad_request
      return
    end

    token = user.generate_token
    render json: {token: token}
  end

  def destroy
    # ログアウト
    current_user.remove_jti
    render json: {message: 'logout successfully.'}
  end
end
