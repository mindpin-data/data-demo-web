class Scourge < ApplicationRecord
  def self.sample
    {
      scourges: [
        {name: '遵义', scourge: '大雨', date: '2017-03-02', long: 113.7, lat: 34.6},
        {name: '郑州', scourge: '大风', date: '2017-03-02', long: 106.9, lat: 27.7},
      ],
    }
  end

  def self.data
    {
      scourges: self.all
    }
  end
end