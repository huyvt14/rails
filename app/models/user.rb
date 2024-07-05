class User < ApplicationRecord
	validates :name, presence: true, length: {maximum: 50}

	before_save :downcase_email

	has_secure_password
	
	def downcase_email 
		self.email.downcase!
	end


end
