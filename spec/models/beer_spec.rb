require 'rails_helper'

# Oluen luonti onnistuu ja olut tallettuu kantaan 
# - jos oluella on nimi, tyyli ja panimo asetettuna
# oluen luonti ei onnistu (eli creatella ei synny validia oliota), 
# -jos sille ei anneta nimeä 
# -jos sille ei määritellä tyyliä
# Jos jälkimmäinen testi ei mene läpi, laajenna koodiasi siten, 
# että se läpäisee testin.

RSpec.describe Beer, type: :model do
  describe "is saved" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "with a proper name, style and brewery" do
      expect(test_beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "is not saved" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer_no_name) { Beer.create style: "teststyle", brewery: test_brewery }
    let(:test_beer_no_style) { Beer.create name: "testbeer", brewery: test_brewery }

    it "without a name" do
      expect(test_beer_no_name).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "without a style" do
      expect(test_beer_no_style).not_to be_valid
      expect(Beer.count).to eq(0)
    end

  end
end
