class User < ApplicationRecord
	validates :name, presence: true, length: {maximum: 50}
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	before_save :downcase_email
	has_secure_password
	before_create :create_activation_digest
	attr_accessor :remember_token, :activation_token

	def downcase_email 
		self.email.downcase!
	end

	# Returns the hash digest of the given string.
	def User.digest(string)
	  cost = if ActiveModel::SecurePassword.min_cost
	           BCrypt::Engine::MIN_COST
	         else
	           BCrypt::Engine.cost
	         end
	  BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_column(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
	  	BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forgets a user.
	def forget
	  update_column(:remember_digest, nil)
	end

	def create_activation_digest
	  self.activation_token = User.new_token
	  self.activation_digest = User.digest(activation_token)
	end

	def authenticated?(attribute, token)
	  digest = send("#{attribute}_digest")
	  return false unless digest
	  
	  BCrypt::Password.new(digest).is_password?(token)
	end
	
	# Activates an account.
	def activate
	  update_columns(activated: true, activated_at: Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
	  UserMailer.account_activation(self).deliver_now
	end


end
