# -*- coding: utf-8 -*-
module MediumCity

  # 训练长枪兵,每个长枪兵花费1金3分钟时间
  class CreateCQB
    @queue = :solider

    def self.perform(options = {})
      num = options['num']
      num.times do
        Solider.create(:kind => Solider::Codes['长枪兵'], :city_id => options['city_id'])
      end
      sq = SoliderQueue.find(options['sq_id'])
      sq.update_attributes(:status => SoliderQueue::Codes['完成'])
    end
    
  end

  # 训练弓箭手,每个弓箭手花费3个金子12分钟的时间
  class CreateGJS
    @queue = :solider

    def self.perform(options = {})
      num = options['num']
      num.times do
        Solider.create(:kind => Solider::Codes['弓箭手'], :city_id => options['city_id'])
      end
      sq = SoliderQueue.find(options['sq_id'])
      sq.update_attributes(:status => SoliderQueue::Codes['完成'])
    end
    
  end

  # 训练骑兵,每个骑兵花费10金和50分钟时间
  class CreateQB
    @queue = :solider

    def self.perform(options = {})
      num = options['num']
      num.times do
        Solider.create(:kind => Solider::Codes['骑兵'], :city_id => options['city_id'])
      end
      sq = SoliderQueue.find(options['sq_id'])
      sq.update_attributes(:status => SoliderQueue::Codes['完成'])
    end
    
  end

  # 食物消耗，长枪兵10/hour, 弓箭手13/hour, 骑兵30/hour，每秒计算一次城市粮食的消耗量
  # 食物量是以float型存储在数据库中，以整型显示
  class SolidersConsumeFood
    @queue = :consume_food
    
    def self.perform
      City.capital_cities.each {|city|
        city.food = city.food - city.consumed_food_per_sec
        city.save!
      }
      City.normal_cities.each {|city|
        city.food = city.food - city.consumed_food_per_sec
        city.save!
      }
    end
    
  end
  
end
