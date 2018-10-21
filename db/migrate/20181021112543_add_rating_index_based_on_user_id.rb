class AddRatingIndexBasedOnUserId < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :user_id
  end
end
