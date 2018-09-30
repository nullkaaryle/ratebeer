require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
    
  end

  describe "in user's profile page" do
    let!(:herkko){ User.create username:"Herkko", password:"Herkko123", password_confirmation:"Herkko123" }
    let!(:pirkko){ User.create username:"Pirkko", password:"Pirkko123", password_confirmation:"Pirkko123" }
    
    it "only user's own ratings are listed" do
      FactoryBot.create(:rating, score: 1, user:herkko)
      FactoryBot.create(:rating, score: 2, user:herkko)
      FactoryBot.create(:rating, score: 3, user:herkko)
      FactoryBot.create(:rating, score: 50, user:pirkko)
      FactoryBot.create(:rating, score: 50, user:pirkko)
      FactoryBot.create(:rating, score: 50, user:pirkko)
      visit user_path(pirkko)

      expect(page).to have_content 'Has made 3 ratings, average rating 50'
    end

    it "user can delete a rating" do
      sign_in(username: "Pirkko", password: "Pirkko123")
      FactoryBot.create(:rating, score: 50, user:pirkko)
      visit user_path(pirkko)
      save_and_open_page
      
      within(".user_ratings") do
        expect{
          click_link('delete')
        }.to change{Rating.count}.by(-1)
      end
        expect(page).to have_content 'Has not given any ratings.'
    end

  end

end
