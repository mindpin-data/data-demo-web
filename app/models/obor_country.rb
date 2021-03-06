class OborCountry < ApplicationRecord
  def self.sample
    {
      countries: [
        { name: '泰国', code: 'THA', total: 1267500, percent_change: 13.2,
          now: [0, 35, 100, 140],
          history: [0, 30, 60, 80, 110, 140],
        },
        { name: '印度', code: 'IND', total: 1567430, percent_change: 14.3,
          now: [0, 35, 100, 140],
          history: [0, 30, 60, 80, 110, 140],
        },
        { name: '越南', code: 'VNM', total: 1707340, percent_change: 15.4,
          now: [0, 35, 100, 140],
          history: [0, 30, 60, 80, 110, 140],
        },
        { name: '马来西亚', code: 'MYS', total: 1903160, percent_change: 16.5,
          now: [0, 35, 100, 140],
          history: [0, 30, 60, 80, 110, 140],
        },
        { name: '印尼', code: 'IDN', total: 2902210, percent_change: 17.6,
          now: [0, 35, 100, 140],
          history: [0, 30, 60, 80, 110, 140],
        },
      ]
    }
  end

  def self.data
    data = self.all

    _data = data.map {|x|
      JSON.parse x.to_json
    }

    _data.each {|x|
      x['now'] = JSON.parse x['now']
      x['history'] = JSON.parse x['history']
    }

    {
      countries: _data
    }
  end
end