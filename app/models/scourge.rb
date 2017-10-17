class Scourge < ApplicationRecord
  def self.sample
    {
      scourges: [
        {name: '遵义', scourge: '大雨', cdate: '2017-03-02', lon: 113.7, lat: 34.6},
        {name: '郑州', scourge: '大风', cdate: '2017-03-02', lon: 106.9, lat: 27.7},
      ],
    }
  end

  def self.data
    data = JSON.parse self.all.to_json
    data.each do |d|
      d['icon'] = PinYin.of_string(d['scourge']).join

      d['date'] = d['cdate'] if d['cdate']
      d['long'] = d['lon'] if d['lon']
    end

    {
      scourges: data
    }
  end
end