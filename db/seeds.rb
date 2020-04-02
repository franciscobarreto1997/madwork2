# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

City.destroy_all

# us_states = CS.get :us

portuguese_cities = CS.get :pt
puts "Creating #{portuguese_cities.count} portuguese cities"
portuguese_cities.each do |key, value|
  City.create!(name: portuguese_cities[key], country: "Portugal")
end

england_cities = %w[London Birmingham Manchester Glasgow Newcastle Sheffield Liverpool Leeds Bristol].sort
puts "Creating #{england_cities.count} english cities"
england_cities.each do |city|
  City.create!(name: city, country: "England")
end

us_states = CS.get :us
puts "Creating #{us_states.count} american states"
us_states.each do |key, value|
  City.create!(name: us_states[key], country: "United States")
end

french_cities = %w[Paris Marseille Lyon Toulouse Nice Nantes Montpellier Strasbourg Bordeaux Lille].sort
puts "Creating #{french_cities.count} french_cities"
french_cities.each do |city|
  City.create!(name: city, country: "France")
end

german_cities = %w[Berlin Hamburg Munich Cologne Frankfurt Essen Stuttgart Dortmund Düsseldorf Bremen Hanover Leipzig].sort
puts "Creating #{german_cities.count} german cities"
german_cities.each do |city|
  City.create!(name: city, country: "Germany")
end

spanish_cities = %w[Madrid Barcelona Valencia Sevilla Zaragoza Málaga Murcia Bilbao Alicante Cordova].sort
puts "Creating #{spanish_cities.count} spanish cities"
spanish_cities.each do |city|
  City.create!(name: city, country: "Spain")
end

dutch_cities = %w[Amsterdam Rotterdam Utrecht Eindhoven Tilburg Groningen Almere Stad Breda Nijmegen].push("The Hague")
puts "Creating #{dutch_cities.count} dutch cities"
dutch_cities.sort.each do |city|
  City.create!(name: city, country: "Netherlands")
end

italian_cities = %w[Roma Milano Napoli Turin Palermo Genoa Bologna Catania Bari Messina].sort
puts "Creating #{italian_cities.count} italian cities"
italian_cities.each do |city|
  City.create!(name: city, country: "Italy")
end


