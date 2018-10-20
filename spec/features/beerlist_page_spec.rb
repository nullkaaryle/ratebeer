require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu']  }
      )

      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities      
    end
      WebMock.disable_net_connect!(allow_localhost: true) 
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    table = find('table')
    expect(table).to have_content "Nikolai"
  end

  it "has beers in alphabetical order as default", js:true do
    visit beerlist_path
    row1 = find('table').find('tr:nth-child(2)')
    expect(row1).to have_content "Fastenbier"
    expect(row1).not_to have_content "Lechte Weisse"
    expect(row1).not_to have_content "Nikolai"
    row2 = find('table').find('tr:nth-child(3)')
    expect(row2).to have_content "Lechte Weisse"
    row3 = find('table').find('tr:nth-child(4)')
    expect(row3).to have_content "Nikolai"
  end

   it "table can be ordered by style", js:true do
      visit beerlist_path
      row0 = find('table').find('tr:nth-child(1)')
      find('a', text: 'Style').click
      row1 = find('table').find('tr:nth-child(2)')
      expect(row1).to have_content "Lager"
      row2 = find('table').find('tr:nth-child(3)')
      expect(row2).to have_content "Rauchbier"
      row3 = find('table').find('tr:nth-child(4)')
      save_and_open_page
      expect(row3).to have_content "Weizen"
   end

   it "table can be ordered by brewery", js:true do
      visit beerlist_path
      row0 = find('table').find('tr:nth-child(1)')
      find('a', text: 'Brewery').click
      row1 = find('table').find('tr:nth-child(2)')
      expect(row1).to have_content "Ayinger"
      row2 = find('table').find('tr:nth-child(3)')
      expect(row2).to have_content "Koff"
      row3 = find('table').find('tr:nth-child(4)')
      expect(row3).to have_content "Schlenkerla"
   end
end