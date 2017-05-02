class Material < ApplicationRecord
  def self.sample
    {
      materials: [
        { name: '大豆', color: '#33ff33', 
          current_now: 4.333, current_history: 4.777, current_guiding: 4.999, percent_change: 1.11,
          now: [45, 45, 40, 48, 42, 50],
          history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
          guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
        },
        { name: '生姜', color: '#ffff33', 
          current_now: 4.222, current_history: 4.666, current_guiding: 4.888, percent_change: 2.22,
          now: [45, 45, 40, 48, 42, 50],
          history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
          guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
        },
        { name: '辣椒', color: '#ff3333', 
          current_now: 4.111, current_history: 4.555, current_guiding: 4.777, percent_change: 3.33,
          now: [45, 45, 40, 48, 42, 50],
          history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
          guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
        },
      ]
    }
  end

  def self.data
    data = self.all.map {|x|
      JSON.parse x.to_json
    }
    data.each {|x|
      x['now'] = JSON.parse x['now']
      x['history'] = JSON.parse x['history']
      x['guiding'] = JSON.parse x['guiding']
    }
    {
      materials: data
    }
  end
end