class User < ApplicationRecord
	validates :name, presence: true, length: {maximum: 50}
	before_save :downcase_email
	has_secure_password

	attr_accessor :remember_token

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

end
