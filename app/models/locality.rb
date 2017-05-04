class Locality < ApplicationRecord
  def self.sample
    {
      localities: [
        { name: 'test', long: 103,   lat: 30,   amount: 30, material: '辣椒'},
        { name: 'test', long: 110,   lat: 29,   amount: 20, material: '辣椒'},
        { name: 'test', long: 106.9, lat: 27.7, amount: 25, material: '辣椒'},
        { name: 'test', long: 104,   lat: 26,   amount: 20, material: '辣椒'},
        { name: 'test', long: 106,   lat: 23,   amount: 20, material: '辣椒'},
        { name: 'test', long: 114.3, lat: 28.7, amount: 20, material: '生姜'},
        { name: 'test', long: 106.3, lat: 29.6, amount: 17, material: '生姜'},
        { name: 'test', long: 103.7, lat: 26.8, amount: 23, material: '生姜'},
        { name: 'test', long: 108.6, lat: 25.5, amount: 24, material: '生姜'},
        { name: 'test', long: 113.7, lat: 34.6, amount: 30, material: '大豆'},
        { name: 'test', long: 105.1, lat: 28.7, amount: 25, material: '大豆'},
        { name: 'test', long: 103.7, lat: 26.8, amount: 24, material: '大豆'},
        { name: 'test', long: 111.8, lat: 24.4, amount: 20, material: '大豆'},
        { name: 'test', long: 100.2, lat: 23.1, amount: 19, material: '大豆'},
      ],
    }
  end

  def self.data
    {
      localities: self.all
    }
  end
end