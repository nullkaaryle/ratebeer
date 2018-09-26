# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1040

br1 = b1.beers.create name:"Iso 3", style:"Lager"
br2 = b1.beers.create name:"Karhu", style:"Lager"
br3 = b1.beers.create name:"Tuplahumala", style:"Lager"
br4 = b2.beers.create name:"Huvila Pale Ale", style:"Pale Ale"
br5 = b2.beers.create name:"X Porter", style:"Porter"
br6 = b3.beers.create name:"Hefeweizen", style:"Weizen"
br7 = b3.beers.create name:"Helles", style:"Lager"

u1 = User.create username:"Pirkko", password:"Pirkko123", password_confirmation:"Pirkko123"
u2 = User.create username:"Kerkko", password:"Kerkko123", password_confirmation:"Kerkko123"
u3 = User.create username:"Herkko", password:"Herkko123", password_confirmation:"Herkko123"

bc1 = BeerClub.create name:"Kumpulan Kaljamo", founded:2016, city:"Helsinki"
bc2 = BeerClub.create name:"Puistolan panimopulut", founded:2002, city:"Helsinki"

br1.ratings.create score:24, user_id:1
br2.ratings.create score:5, user_id:1
br3.ratings.create score:12, user_id:1
br4.ratings.create score:35, user_id:1
br5.ratings.create score:22, user_id:1
br6.ratings.create score:17, user_id:2
br7.ratings.create score:35, user_id:2
br3.ratings.create score:12, user_id:2
br4.ratings.create score:35, user_id:2
br5.ratings.create score:22, user_id:2
br6.ratings.create score:17, user_id:2

u1.memberships.create beer_club_id:1
u1.memberships.create beer_club_id:2
u2.memberships.create beer_club_id:2
