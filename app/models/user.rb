# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: Settings.user.name.presence,
                   length: { maximum: Settings.user.name.length.maximum }

  before_save :downcase_email

  has_secure_password

  def downcase_email
    email.downcase!
  end
end
