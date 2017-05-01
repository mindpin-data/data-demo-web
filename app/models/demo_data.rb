class DemoData
  class << self
    def demo1
      OborCountry.data
    end

    def demo2
      {
        localities: [
          { long: 103,   lat: 30,   amount: 30, material: '辣椒'},
          { long: 110,   lat: 29,   amount: 20, material: '辣椒'},
          { long: 106.9, lat: 27.7, amount: 25, material: '辣椒'},
          { long: 104,   lat: 26,   amount: 20, material: '辣椒'},
          { long: 106,   lat: 23,   amount: 20, material: '辣椒'},
          { long: 114.3, lat: 28.7, amount: 20, material: '生姜'},
          { long: 106.3, lat: 29.6, amount: 17, material: '生姜'},
          { long: 103.7, lat: 26.8, amount: 23, material: '生姜'},
          { long: 108.6, lat: 25.5, amount: 24, material: '生姜'},
          { long: 113.7, lat: 34.6, amount: 30, material: '大豆'},
          { long: 105.1, lat: 28.7, amount: 25, material: '大豆'},
          { long: 103.7, lat: 26.8, amount: 24, material: '大豆'},
          { long: 111.8, lat: 24.4, amount: 20, material: '大豆'},
          { long: 100.2, lat: 23.1, amount: 19, material: '大豆'},
        ],
        scourges: [
          {name: '遵义', scourge: '大雨', date: '2017-03-02', long: 113.7, lat: 34.6},
          {name: '郑州', scourge: '大风', date: '2017-03-02', long: 106.9, lat: 27.7},
        ],
        materials: [
          { name: '大豆', color: '#3f3', 
            current_now: 4.333, current_history: 4.777, current_guiding: 4.999, percent_change: 1.11,
            now: [45, 45, 40, 48, 42, 50],
            history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
            guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
          },
          { name: '生姜', color: '#ff3', 
            current_now: 4.222, current_history: 4.666, current_guiding: 4.888, percent_change: 2.22,
            now: [45, 45, 40, 48, 42, 50],
            history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
            guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
          },
          { name: '辣椒', color: '#f33', 
            current_now: 4.111, current_history: 4.555, current_guiding: 4.777, percent_change: 3.33,
            now: [45, 45, 40, 48, 42, 50],
            history: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47],
            guiding: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60],
          },
        ]
      }
    end

    def demo3
      {}.merge(CityAmount.data).merge(TotalAmount.data)
    end
  end
end