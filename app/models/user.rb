class User < ApplicationRecord
	has_many :microposts, dependent: :destroy

	has_many :active_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
	has_many :passive_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	validates :name, presence: true, length: {maximum: 50}
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	before_save :downcase_email
	has_secure_password
	before_create :create_activation_digest
	attr_accessor :remember_token, :activation_token, :reset_token

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


	def create_reset_digest
	  self.reset_token = User.new_token
	  update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
	end

	def send_password_reset_email
	  UserMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	def feed
		# Micropost.relate_post(following_ids << id).includes(:user, image_attachment: :blob)
		Micropost.relate_post(following_ids << id)
	end


	
	def follow(other_user)
	  # Follows a user.
	  following << other_user
	end

	def unfollow(other_user)
	  # Unfollows a user.
	  following.delete(other_user)
	end

	def following?(other_user)
	  # Returns if the current user is following the other_user or not.
	  following.include?(other_user)
	end

end
