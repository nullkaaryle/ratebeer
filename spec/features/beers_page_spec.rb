require 'rails_helper'

include Helpers

describe "Beer" do
  before :each do
    FactoryBot.create(:brewery, name: 'TestBrewery')
  end

  it "when given a valid name, is added to the system" do
    visit new_beer_path
      fill_in('beer_name', with:'TestBeer')

      expect{
        click_button('Create Beer')
        }.to change{Beer.count}.by(1)
  end


  describe "when not a given a name" do
    before :each do
      visit new_beer_path
      fill_in('beer_name', with:'')
      click_button('Create Beer')
    end

    it "is not added to the system" do
      expect(Beer.count).to eq(0)
    end
    
    it "an error notification is shown to user" do
      expect(page).to have_content "error prohibited this beer from being saved"
      expect(page).to have_content "Name can't be blank"
    end
  end
end