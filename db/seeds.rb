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


