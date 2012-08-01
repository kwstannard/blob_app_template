require 'bcrypt'

class User < Instance
  attr_accessor :password_hash, :password_salt, :locale
  instance_indices :email
end
