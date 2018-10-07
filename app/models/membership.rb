class Membership < ApplicationRecord
  belongs_to :beer_club
  belongs_to :user

  validates :beer_club, uniqueness: { scope: :user }
end
