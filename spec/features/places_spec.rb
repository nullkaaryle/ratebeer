require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new( name:"Oljenkorsi", id: 1 )]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
  end

  it "if two is returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Humalankukinto", id: 2 )]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Humalankukinto"
  end

  it "if none is returned by the API, message is shown at the page" do
    city = 'kumpula'
    allow(BeermappingApi).to receive(:places_in).with(city).and_return(
      []
    )

    visit places_path
    fill_in('city', with: city)
    click_button "Search"
    save_and_open_page
    expect(page).to have_content "No locations in #{city}"
  end
end
