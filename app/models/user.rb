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

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group: group, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
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
