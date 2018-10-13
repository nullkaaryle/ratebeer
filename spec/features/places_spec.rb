require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("puotila").and_return(
      [ 
        Place.new( name: "Pikkulintu", id: 1 ),
        Place.new( name: "Puotinkrouvi", id: 2 ) 
      ]
    )

    visit places_path
    fill_in('city', with: 'puotila')
    click_button "Search"

    expect(page).to_not have_content "Oljenkorsi"
    expect(page).to have_content "Pikkulintu"
    expect(page).to have_content "Puotinkrouvi"
  end  

  it "if none is returned by the API, use is notified" do
    allow(BeermappingApi).to receive(:places_in).with("tapanila").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'tapanila')
    click_button "Search"

    expect(page).to have_content "No locations in tapanila"
  end  
end