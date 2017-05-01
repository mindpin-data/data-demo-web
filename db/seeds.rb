# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 一带一路
obor_countries = OborCountry.sample[:countries]
obor_countries.each {|x|
  x[:now] = x[:now].to_json
  x[:history] = x[:history].to_json
}
obor_countries.each {|x|
  OborCountry.create(x)
}

# 全球销量
CityAmount.sample[:cn_cities].each {|x|
  x[:in_china] = true
  CityAmount.create(x)
}

CityAmount.sample[:world_cities].each {|x|
  x[:in_china] = false
  CityAmount.create(x)
}

TotalAmount.create(TotalAmount.sample)