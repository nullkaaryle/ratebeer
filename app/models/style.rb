class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.top(number_of_top_rated)
    sql = %{
      select styles.*
      from ratings
      inner join styles on styles.id = ratings.beer_id
      group by styles.id, ratings.beer_id
      order by avg(ratings.score) desc
      limit ?;
    }

    Beer.find_by_sql([sql, number_of_top_rated])

    #sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating || 0) }
    #sorted_by_rating_in_desc_order.take(number_of_top_rated)
  end
end
