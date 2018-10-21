class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: ->(_) { Time.now.year },
                                   only_integer: true }
  validates :name, presence: true

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def self.top(number_of_top_rated)
    sql = %{
      select breweries.*
      from ratings
      inner join breweries on breweries.id = ratings.beer_id
      group by breweries.id, ratings.beer_id
      order by avg(ratings.score) desc
      limit ?;
    }

    Beer.find_by_sql([sql, number_of_top_rated])

    #sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    #sorted_by_rating_in_desc_order.take(number_of_top_rated)
  end
end
