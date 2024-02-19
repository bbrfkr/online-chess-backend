class SessionsController < ApplicationController
  # loginではjwt検証をしない
  skip_before_action :_verify_token, only: [:new]

  def new
    # loginし、jwt tokenを発行する
    user = User.find_by(email: params['email'])
    unless user && user.authenticate(params[:password])
      render json: { error: 'Invalid user information' }, status: :bad_request
      return
    end

    # jwt tokenの生成
    jti = SecureRandom.uuid 
    exp = (Time.now + 1.hour).to_i
    payload = {exp:, jti:, user_id: user.id}
    token = JWT.encode(payload, Rails.application.credentials.secret_key_base)

    # jtiの更新
    user.jti = jti
    user.save

    render json: {token: token}
  end

  def destroy
    current_user.update(jti: nil)
    render json: {message: 'logout successfully.'}
  end
end
