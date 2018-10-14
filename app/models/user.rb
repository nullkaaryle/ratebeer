class User < ApplicationRecord
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_secure_password

  validates :username,  uniqueness: true,
                        length: { minimum: 3, maximum: 30 }

  validates :password,  length: { minimum: 4 },
                        presence: true,
                        format: { with: /([A-Z]+.*\d+)|(\d+.*[A-Z]+)/ }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    return nil if ratings.empty?

    sql = %{
      select br.*
      from ratings r
      inner join beers be on be.id = r.beer_id
      inner join breweries br on br.id = be.brewery_id
      where r.user_id = ?
      group by br.id, br.name
      order by avg(r.score) desc
      limit 1;
    }

    Brewery.find_by_sql([sql, id]).first
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.group_by{ |r| r.beer.style }
    averages = style_ratings.map do |style, ratings|
      { style: style, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:style]
  end

  def self.top(number_of_top_rated)
    sql = %{
      select u.*
      from ratings r
      inner join users u on u.id = r.user_id
      group by r.user_id, u.id
      order by count(r.user_id) desc
      limit ?
    }

    User.find_by_sql([sql, number_of_top_rated])
  end
end
