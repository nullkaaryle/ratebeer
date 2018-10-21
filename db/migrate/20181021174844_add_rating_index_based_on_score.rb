class AddRatingIndexBasedOnScore < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :score
  end
end
