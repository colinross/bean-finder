# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

# When it matters, I can find a way to make better coordinates for seeds 
10.times do |i|
  Location.create(lonlat: "POINT(#{i} #{-i})")
end
