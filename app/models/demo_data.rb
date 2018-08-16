class DemoData
  class << self
    def demo1
      OborCountry.data
    end

    def demo2
      {}.merge(Material.data).merge(Scourge.data).merge(Locality.data)
    end

    def demo3(params)
      {}.merge(CityAmount.data).merge(TotalAmount.data)
    end
  end
end