class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name} (#{brewery.name})"
  end

  def to_good_beer
    "#{name} (#{brewery.name}), YUM YUM!"
  end

  def self.top(number_of_top_rated)
    sql = %{
      select beers.*
      from ratings
      inner join beers on beers.id = ratings.beer_id
      group by beers.id, ratings.beer_id
      order by avg(ratings.score) desc
      limit ?;
    }

    Beer.find_by_sql([sql, number_of_top_rated])

    # sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    # sorted_by_rating_in_desc_order.take(number_of_top_rated)
  end
end
