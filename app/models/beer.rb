class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating
        sum = 0.0
        count = 0
        ratings = Rating.where(beer_id: self.id) 

        ratings.each do |rating|
            sum = sum + rating.score
            count = count + 1
        end

        sum / count
    end

end