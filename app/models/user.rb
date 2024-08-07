# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: Settings.user.name.presence,
                   length: { maximum: Settings.user.name.length.maximum }

  before_save :downcase_email

  has_secure_password

  def downcase_email
    email.downcase!
  end

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end
end
