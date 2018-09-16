class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating
        Rating.where(beer_id: self.id).average(:score)
    end

    def to_s
        "#{self.name} (#{self.brewery.name})"
    end

end