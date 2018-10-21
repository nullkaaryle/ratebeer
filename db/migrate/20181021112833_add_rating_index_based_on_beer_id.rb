class AddRatingIndexBasedOnBeerId < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :beer_id
  end
end
