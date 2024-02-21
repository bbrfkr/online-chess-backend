class User < ApplicationRecord
  has_secure_password

  def generate_token
    # jwt tokenを生成する
    jti = SecureRandom.uuid
    exp = (Time.now + 1.hour).to_i
    payload = {exp:, jti:, user_id: self.id}
    token = JWT.encode(payload, Rails.application.credentials.secret_key_base)

    # jtiの更新
    self.jti = jti
    self.save

    return token
  end

  def remove_jti
    # jtiを空にする
    self.update(jti: nil)
  end
end
