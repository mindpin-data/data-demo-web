class TotalAmount < ApplicationRecord
  def self.sample
    {
      total: 888888888,
      export: 122222222,
      now: [0.7, 0.8, 1.5, 2.0, 2.6, 3.2, 3.8, 5.2, 5.9, 6.6, 7.0, 8.4],
      forecast: [0, 0.6, 1.3, 2.2, 2.7, 3.1, 3.5, 5.0, 5.4, 6.0, 6.6, 7.5],
      history: [0, 0.4, 1.0, 1.2, 1.9, 2.0, 2.6, 3.2, 3.7, 4.1, 4.3, 4.9],
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