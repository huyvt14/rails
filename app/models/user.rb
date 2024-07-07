class User < ApplicationRecord
	validates :name, presence: true, length: {maximum: 50}

	before_save :downcase_email

	has_secure_password
	
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


end
