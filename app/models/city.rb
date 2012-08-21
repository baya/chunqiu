# -*- coding: utf-8 -*-
class City < ActiveRecord::Base
  belongs_to :user
  has_many :soliders
  has_many :solider_queues
  # 对外攻击
  has_many :fights, :foreign_key => 'origin_city_id'
  # 敌对攻击
  has_many :attacked_fights, :foreign_key => 'target_city_id', :class_name => 'Fight'
  
  scope :capital_cities, where(:capital => true)
  scope :normal_cities, where(:capital => [false, nil])
  

  validates_presence_of :name, :food, :human, :gold, :tax_rate
  validates_numericality_of :tax_rate,
  :greater_than_or_equal_to => 0,
  :less_than_or_equal_to    => 1.0
  validates_numericality_of :food, :gold
  validates_numericality_of :human, :only => :integer

  # 城市的半径
  Rd = 50 * Math.sqrt(2)

  # 初始化资源
  def init_resources
    self.food     = 0.0
    self.human    = 100
    self.gold     = 0
    self.tax_rate = 0.2
    self.capital  = false
  end

  # 征税
  def take_tax
    rest_gold = gold - gold * tax_rate
    self.gold = rest_gold.to_i
    float_human = human * 0.05 >= 1000 ? 1000 : human * 0.05
    float_human = 1 if float_human < 1
    if human < tax_rate * 1000
      self.increment(:human, float_human.to_i)
    else
      self.decrement(:human, float_human.to_i)
    end
    # 如果发生粮食危机，各个兵种减少10%
    soliders_dead_due_lacking_food if self.food < 0.0
    res = save
  end

  # 由于粮食危机，各个兵种减少10%
  def soliders_dead_due_lacking_food
    cqb_dead_num = (cqb_soliders.count * 0.1).round
    gjs_dead_num = (gjs_soliders.count * 0.1).round
    qb_dead_num = (qb_soliders.count * 0.1).round
    cqb_dead_num.times {|i| cqb_soliders[i].dead!}
    gjs_dead_num.times {|i| gjs_soliders[i].dead!}
    qb_dead_num.times {|i| qb_soliders[i].dead!}
  end

  # 长枪兵
  def cqb_soliders
    soliders.live.cqb
  end

  # 弓箭手
  def gjs_soliders
    soliders.live.gjs
  end

  # 骑兵
  def qb_soliders
    soliders.live.qb
  end

  # 如果食物的数量小于0,显示0
  def h_food
    self.food < 0 ? 0 : self.food.to_i
  end

  # 训练中的士兵队列
  def waiting_solider_queues
    solider_queues.where(:status => SoliderQueue::Codes['等待'])
  end

  # 每小时消耗食物数量
  def consumed_food_per_hour
    cqb_food = cqb_soliders.count * 10
    gjs_food = gjs_soliders.count * 13
    qb_food  = qb_soliders.count  * 30
    cqb_food + gjs_food + qb_food
  end

  # 每秒消耗食物量
  def consumed_food_per_sec
    consumed_food_per_hour / 3600.0
  end

  # 计算两座城市间的距离，任意两个城市都是不相交的
  # 计算方法是两城市中心点间的距离减去两个城市的半径之和
  # 并且将计算出的结果四舍五入取整
  def distance_to(a_city)
    origin_distance = get_origin_distance(a_city)
    (origin_distance - Rd * 2).round
  end  

  # 获得城市的原点
  def get_origin
    origin_x = pos_x + 50
    origin_y = pos_y + 50
    return origin_x, origin_y
  end

  # 获得城市间原点距离
  def get_origin_distance(a_city)
    x1, y1 = get_origin
    x2, y2 = a_city.get_origin
    Math.sqrt((x2 - x1) * (x2 - x1) + (y2- y1) * (y2- y1))
  end 

  # 发起一次攻击
  def create_a_fight(fight)
    cqb_ready = cqb_soliders.free.count >= fight['cqb_num'].to_i
    gjs_ready = gjs_soliders.free.count >= fight['gjs_num'].to_i
    qb_ready = qb_soliders.free.count >= fight['qb_num'].to_i
    if cqb_ready and gjs_ready and qb_ready
      a_fight = self.fights.create(:target_city_id => fight['target_city_id'],
                                   :status => Fight::StatusCodes['外出']
                                   )
      call_cqb_soliders_to_fight(fight['cqb_num'].to_i, a_fight)
      call_gjs_soliders_to_fight(fight['gjs_num'].to_i, a_fight)
      call_qb_soliders_to_fight(fight['qb_num'].to_i,   a_fight)
      return a_fight
    end
  end

  # 召集长枪兵
  def call_cqb_soliders_to_fight(num, fight)
    num.times {|i|
      next if cqb_soliders.free[i].nil?
      cqb_soliders.free[i].attend_fight!(fight)
    }
  end

  # 召集弓箭手
  def call_gjs_soliders_to_fight(num, fight)
    num.times {|i|
      next if gjs_soliders.free[i].nil?
      gjs_soliders.free[i].attend_fight!(fight)
    }
  end

  # 召集骑兵
  def call_qb_soliders_to_fight(num, fight)
    num.times {|i|
      next if qb_soliders.free[i].nil?
      qb_soliders.free[i].attend_fight!(fight)
    }
  end

  # 判断是否受到攻击
  def be_attacked?
    attacked_fights.walk_fire.count > 0
  end  


end
