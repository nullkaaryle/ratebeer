require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "there should not exist any before been created" do
    visit ratings_path
    
    expect(Rating.count).to eq(0)
    expect(page).to have_content "No ratings given yet"
  end 

  it "total number of ratings is shown on Ratings page" do
    FactoryBot.create(:rating, score: 11, user:user)
    FactoryBot.create(:rating, score: 12, user:user)
    FactoryBot.create(:rating, score: 13, user:user)
    visit ratings_path
    
    expect(Rating.count).to eq(3)
    expect(page).to have_content "Our users have given 3 ratings"
  end

end
