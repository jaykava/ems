# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
puts "==============================================="
puts "Data is being genrate...."
puts "==============================================="


100.times do
  Employee.create!(
    {
      full_name: Faker::Name.unique.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.cell_phone_in_e164,
      position: Faker::Job.position,
      status: [ :active, :inactive ].sample
    }
  )
end

puts "Data genrated done."
