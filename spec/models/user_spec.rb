require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  describe  "is not saved " do
    let(:user1){ User.create username:"Pekka" }
    let(:user2){ User.create username:"Pekka", password:"Secret", password_confirmation:"Secret" }
    let(:user3){ User.create username:"Pekka", password:"Sec", password_confirmation:"Sec" }

    it "without a password" do
      expect(user1).not_to be_valid
      expect(User.count).to eq(0)
    end
    
    it "with a bad password that is too simple" do
      expect(user2).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with a bad password that is too short " do
      expect(user3).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

    describe "favorite beer" do
      let(:user){ FactoryBot.create(:user) }
    
      it "has method for determining the favorite_beer" do
        expect(user).to respond_to(:favorite_beer)
      end

      it "without ratings does not have a favorite beer" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one rating" do
        beer = FactoryBot.create(:beer)
        rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
        
        expect(user.favorite_beer).to eq(beer)
      end

      it "is the one with highest rating if several rated" do
        create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
        best = create_beer_with_rating({ user: user }, 25 )

        expect(user.favorite_beer).to eq(best)
      end     
    end

    describe "favorite brewery" do
      let(:user){ FactoryBot.create(:user) }
      let(:test_brewery) { Brewery.new name: "test", year: 2000 }
      let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }
    
      it "has method for determining the favorite brewery" do
        expect(user).to respond_to(:favorite_brewery)
      end

      it "without ratings does not have a favorite brewery" do
        expect(user.ratings.count).to eq(0)
        expect(user.favorite_brewery).to eq(nil)
      end

       it "is the one with highest total ratings if several rated" do
        create_beers_with_many_ratings({user: user}, 10, 20, 30)
        
        FactoryBot.create(:rating, beer: test_beer, score: 40, user: user )
        expect(user.favorite_brewery).to eq(test_brewery)
      end  
    end
    
    describe "favorite style" do

      it "has method for determining the favorite style" do
        expect(user).to respond_to(:favorite_style)
      end

       it "without ratings does not have a favorite style" do
        expect(user.ratings.count).to eq(0)
        expect(user.favorite_style).to eq(nil)
      end
    
    end

  end

  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end
end
