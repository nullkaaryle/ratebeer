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

  def favorite_style
    return nil if ratings.empty?

    sql = %{
      select beers.style
      from ratings
      inner join beers on beers.id = ratings.beer_id
      where ratings.user_id = ?
      group by beers.style
      order by avg(ratings.score) desc
      limit 1;
    }

    Beer.find_by_sql([sql, id]).first.style
  end
end
