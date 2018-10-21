class AddBeerIndexBasedOnBreweryId < ActiveRecord::Migration[5.2]
  def change
    add_index :beers, :brewery_id
  end
end
