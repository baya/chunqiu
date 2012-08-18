# -*- coding: utf-8 -*-
module Scheduler

  CapitalFoodInc = 100 * 100 / (3600 / 9)
  CityFoodInc = 100 * 10 / (3600 / 18)

  # 作业中没有涉及到金子是怎生产的，我在这里假设首都城市每小时产出500金，普通城市每小时产出50金
  CapitalGold = 500 / (3600 / 36)
  CityGold = 50 / (3600 / 72)

  # 每9秒运行一次, 首都城市生产25食物
  def capital_produce_food
    City.capital_cities.each {|city| city.increment!(:food, CapitalFoodInc) } 
  end

  # 每18秒执行一次，普通城市生产5食物
  def city_produce_food
    City.normal_cities.each {|city| city.increment!(:food, CityFoodInc)}
  end

  # 每36秒执行一次，首都城市生产5金
  def capital_produce_gold
    City.capital_cities.each {|city| city.increment!(:gold, CapitalGold)}
  end

  # 每72秒执行一次，普通城市生产1金
  def city_produce_gold
    City.normal_cities.each {|city| city.increment!(:gold, CityGold)}
  end

  # 每小时执行一次，对所有金子征税
  def take_tax
    City.capital_cities.each {|city| city.take_tax}
    City.normal_cities.each {|city| city.take_tax}
  end

  
end
