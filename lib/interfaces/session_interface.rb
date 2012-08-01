require 'bcrypt'

class NoUserFound < RuntimeError; end
class WrongPassword < RuntimeError; end
class BadPasswordConfirmation < RuntimeError; end
class BadPassword < RuntimeError; end

module SessionInterface
  def fetch_user(email)
    emit_user_by_email(email)
  rescue InstanceHandler::InstanceNotFound
    raise NoUserFound
  end

  def create_user(params)
    raise BadPasswordConfirmation if params[:password] != params[:password_confirmation]
    raise BadPassword if params[:password] == ''
    user = User.new email: params[:email]
    encrypt_password user, params[:password]
    absorb user
  end

  def password_matches?(user, password)
    given_password_hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    (user.password_hash == given_password_hash) || (raise WrongPassword)
  end

  def encrypt_password(user, pass)
    user.password_salt = BCrypt::Engine.generate_salt
    user.password_hash = BCrypt::Engine.hash_secret(pass, user.password_salt)
  end
end
