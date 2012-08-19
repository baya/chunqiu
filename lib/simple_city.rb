# -*- coding: utf-8 -*-
module SimpleCity

  extend self

  CapitalFoodInc = 100 * 100 / (3600 / 9)
  CityFoodInc = 100 * 10 / (3600 / 18)

  # 作业中没有涉及到金子是怎生产的，我在这里假设首都城市每小时产出500金，普通城市每小时产出50金
  CapitalGold = 500 / (3600 / 36)
  CityGold = 50 / (3600 / 72)

  # 每9秒运行一次, 首都城市生产25食物
  class CapitalProduceFood
    @queue = :food
    
    def self.perform
      City.capital_cities.each {|city| city.increment!(:food, CapitalFoodInc) } 
    end
  end

  # 每18秒执行一次，普通城市生产5食物
  class CityProduceFood
    @queue = :food
    
    def self.perform
      City.normal_cities.each {|city| city.increment!(:food, CityFoodInc)}
    end
  end

  # 每36秒执行一次，首都城市生产5金
  class CapitalProduceGold
    @queue = :gold
    
    def self.perform
      City.capital_cities.each {|city| city.increment!(:gold, CapitalGold)}
    end
  end

  # 每72秒执行一次，普通城市生产1金
  class CityProduceGold
    @queue = :gold
    
    def self.perform
      City.normal_cities.each {|city| city.increment!(:gold, CityGold)}
    end
  end

  # 每小时执行一次，对所有金子征税
  class TakeTax
    @queue = :tax

    def self.perform
      City.capital_cities.each {|city| city.take_tax}
      City.normal_cities.each {|city| city.take_tax}
    end
  end
  
end
