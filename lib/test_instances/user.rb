require 'bcrypt'

class User
  include Instance
  attr_accessor :password_hash, :password_salt, :locale
  instance_indices :email
end
