class Material < ApplicationRecord
  def self.sample
    {
      materials: [
        { name: '大豆', color: '#33ff33', 
          locality_1: '产地一',
          locality_2: '产地二',
          locality_3: '产地三',
          locality_4: '产地四',
          locality_1_data: [45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47, 50],
          locality_2_data: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47],
          locality_3_data: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58],
          locality_4_data: [52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58, 55],
        },
        { name: '生姜', color: '#ffff33', 
          locality_1: '产地一',
          locality_2: '产地二',
          locality_3: '产地三',
          locality_4: '产地四',
          locality_1_data: [45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47, 50],
          locality_2_data: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47],
          locality_3_data: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58],
          locality_4_data: [52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58, 55],
        },
        { name: '辣椒', color: '#ff3333', 
          locality_1: '产地一',
          locality_2: '产地二',
          locality_3: '产地三',
          locality_4: '产地四',
          locality_1_data: [45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47, 50],
          locality_2_data: [50, 45, 35, 40, 45, 48, 50, 55, 58, 49, 42, 47, 49, 42, 47],
          locality_3_data: [55, 52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58],
          locality_4_data: [52, 51, 57, 58, 59, 61, 64, 53, 58, 59, 60, 51, 57, 58, 55],
        },
      ]
    }
  end

  def self.data
    data = self.all.map {|x|
      JSON.parse x.to_json
    }
    data.each {|x|
      x['locality_1_data'] = JSON.parse x['locality_1_data']
      x['locality_2_data'] = JSON.parse x['locality_2_data']
      x['locality_3_data'] = JSON.parse x['locality_3_data']
      x['locality_4_data'] = JSON.parse x['locality_4_data']
    }
    {
      materials: data
    }
  end
end