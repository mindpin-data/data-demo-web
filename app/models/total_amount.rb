class TotalAmount < ApplicationRecord
  def self.sample
    {
      total: 888888888,
      export: 122222222,
      now: [0, 8, 15, 20, 26, 32, 38, 52, 59, 66, 70, 84],
      forecast: [0, 6, 13, 22, 27, 31, 35, 50, 54, 60, 66, 75],
      history: [0, 4, 10, 12, 19, 20, 26, 32, 37, 41, 43, 49],
    }
  end

  def self.data
    d = JSON.parse self.last.to_json
    d['now'] = JSON.parse d['now']
    d['forecast'] = JSON.parse d['forecast']
    d['history'] = JSON.parse d['history']
    d
  end
end