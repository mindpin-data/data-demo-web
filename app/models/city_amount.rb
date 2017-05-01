class CityAmount < ApplicationRecord
  def self.sample
    {
      cn_cities: [
        { name: '北京　', amount: 7355291,  long: 116.4, lat: 39.9 },
        { name: '天津　', amount: 3963604,  long: 117.2, lat: 39.1 },
        { name: '河北　', amount: 20813492, long: 114.3, lat: 38.0 },
        { name: '山西　', amount: 10654162, long: 112.3, lat: 37.6 },
        { name: '内蒙古', amount: 8470472,  long: 111.4, lat: 40.5 },
        { name: '辽宁　', amount: 15334912, long: 123.3, lat: 41.5 },
        { name: '吉林　', amount: 9162183,  long: 125.2, lat: 43.5 },
        { name: '黑龙江', amount: 13192935, long: 126.4, lat: 45.4 },
        { name: '上海　', amount: 8893483,  long: 121.2, lat: 31.1 },
        { name: '江苏　', amount: 25635291, long: 118.5, lat: 32.0 },
        { name: '浙江　', amount: 20060115, long: 120.2, lat: 30.2 },
        { name: '安徽　', amount: 19322432, long: 117.2, lat: 31.5 },
        { name: '福建　', amount: 11971873, long: 119.2, lat: 26.0 },
        { name: '江西　', amount: 11847841, long: 115.6, lat: 28.4 },  
        { name: '山东　', amount: 30794664, long: 117.0, lat: 36.4 },  
        { name: '河南　', amount: 26404973, long: 113.4, lat: 34.5 },  
        { name: '湖北　', amount: 17253385, long: 114.2, lat: 30.3 },  
        { name: '湖南　', amount: 19029894, long: 112.6, lat: 28.1 },  
        { name: '广东　', amount: 32222752, long: 113.2, lat: 23.1 },  
        { name: '广西　', amount: 13467663, long: 108.2, lat: 22.4 },  
        { name: '海南　', amount: 2451819,  long: 110.2, lat: 20.0 },
        { name: '重庆　', amount: 10272559, long: 106.4, lat: 29.5 },  
        { name: '四川　', amount: 26383458, long: 104.0, lat: 30.4 },  
        { name: '贵州　', amount: 10745630, long: 106.4, lat: 26.3 },  
        { name: '云南　', amount: 12695396, long: 102.4, lat: 25.0 },  
        { name: '西藏　', amount: 689521,   long: 91.1,  lat: 29.4 },
        { name: '陕西　', amount: 11084516, long: 108.6, lat: 34.2 },  
        { name: '甘肃　', amount: 7113833,  long: 103.5, lat: 36.0 },
        { name: '青海　', amount: 1586635,  long: 101.5, lat: 36.3 },
        { name: '宁夏　', amount: 1945064,  long: 106.2, lat: 38.3 },
        { name: '新疆　', amount: 6902850,  long: 87.4,  lat: 43.5 },
        { name: '台湾　', amount: 8222222,  long: 121.3, lat: 25.0 },
      ],
      world_cities: [
        { name: '莫斯科', amount: 17355291,  long: 37.4,   lat: 55.5 },
        { name: '柏林　', amount: 17355291,  long: 13.3,   lat: 52.3 },
        { name: '伦敦　', amount: 17355291,  long: 0.1,    lat: 51.3 },
        { name: '巴黎　', amount: 17355291,  long: 2.2,    lat: 48.5 },
        { name: '罗马　', amount: 17355291,  long: 12.3,   lat: 41.5 },
        { name: '华盛顿', amount: 17355291,  long: -77.0,  lat: 38.5 },
        { name: '首尔　', amount: 17355291,  long: 126.1,  lat: 37.3 },
        { name: '东京　', amount: 17355291,  long: 139.5,  lat: 35.4 },
        { name: '洛杉矶', amount: 17355291,  long: -118.2, lat: 34.5 },
        { name: '新加坡', amount: 17355291,  long: 103.5,  lat: 1.2  },

        { name: '雅加达　　', amount: 17355291,  long: 106.5, lat: -6.1  },
        { name: '里约热内卢', amount: 17355291,  long: -43.2, lat: -22.5 },
        { name: '圣地亚哥　', amount: 17355291,  long: -70.4, lat: -33.3 },
        { name: '悉尼　　　', amount: 17355291,  long: 151.1, lat: -33.3 },
        { name: '奥克兰　　', amount: 17355291,  long: 174.5, lat: -36.5 },
        { name: '墨尔本　　', amount: 17355291,  long: 144.6, lat: -37.5 },
        { name: '新德里　　', amount: 17355291,  long: 77.2,  lat: 28.5  },
        { name: '开普敦　　', amount: 17355291,  long: 19.0,  lat: -34.0 },
      ]
    }
  end

  def self.data
    {
      cn_cities: self.where(in_china: true),
      world_cities: self.where(in_china: false)
    }
  end
end