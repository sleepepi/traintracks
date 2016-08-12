# frozen_string_literal: true

# Allows models to authenticate using a token.
module TokenAuthenticatable
  extend ActiveSupport::Concern

  # These methods are available to the class.
  module ClassMethods
    def find_by_authentication_token(authentication_token = nil)
      find_by authentication_token: authentication_token if authentication_token
    end
  end

  def ensure_authentication_token
    return if authentication_token.present?
    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
    save
  end

  def id_and_auth_token
    "#{id}-#{authentication_token}"
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.unscoped.find_by authentication_token: token
    end
  end
end
