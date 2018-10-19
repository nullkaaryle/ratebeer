require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    allow(ApixuApi).to receive(:weather_in).with("kumpula").and_return(
       {:last_updated_epoch=>1539506714, :last_updated=>"2018-10-14 11:45", :temp_c=>14.0, :temp_f=>57.2, :is_day=>1, "condition"=>{:text=>"Partly cloudy", "icon"=>"", :code=>1003}, :wind_mph=>8.1, "wind_kph"=>13.0, :wind_degree=>200, :wind_dir=>"SSW", :pressure_mb=>1023.0, :pressure_in=>30.7, :precip_mm=>0.0, :precip_in=>0.0, :humidity=>88, :cloud=>25, :feelslike_c=>13.1, :feelslike_f=>55.5, :vis_km=>8.0, :vis_miles=>4.0}
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
    allow(ApixuApi).to receive(:weather_in).with("puotila").and_return(
{:last_updated_epoch=>1539506714, :last_updated=>"2018-10-14 11:45", :temp_c=>14.0, :temp_f=>57.2, :is_day=>1, "condition"=>{:text=>"Partly cloudy", "icon"=>"", :code=>1003}, :wind_mph=>8.1, "wind_kph"=>13.0, :wind_degree=>200, :wind_dir=>"SSW", :pressure_mb=>1023.0, :pressure_in=>30.7, :precip_mm=>0.0, :precip_in=>0.0, :humidity=>88, :cloud=>25, :feelslike_c=>13.1, :feelslike_f=>55.5, :vis_km=>8.0, :vis_miles=>4.0}
      
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