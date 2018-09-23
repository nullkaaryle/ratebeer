class User < ApplicationRecord
  include RatingAverage

  has_many :ratings
  has_many :beers, through: :ratings
  has_secure_password

  validates :username,  uniqueness: true,
                        length: { minimum: 3, maximum: 30 }

  validates :password,  length: { minimum: 4 },
                        presence: true,
                        format: { with: /([A-Z]+.*\d+)|(\d+.*[A-Z]+)/ }
end
