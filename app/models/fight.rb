# -*- coding: utf-8 -*-
class Fight < ActiveRecord::Base

  StatusCodes = {'外出' => 0, '战斗' => 1, '返回' => 2, '结束' => 3}
  CodeToStatus = {0 => '外出', 1 => '战斗', 2 => '返回', 3 => '结束'}

  has_many :soliders
  belongs_to :origin_city, :class_name => 'City'
  belongs_to :target_city, :class_name => 'City'

  # 外出
  scope :walk,   where(:status => StatusCodes['外出'])
  # 返回
  scope :return, where(:status => StatusCodes['返回'])
  # 结束
  scope :close,  where(:status => StatusCodes['结束'])
  # 外出 + 战斗
  scope :walk_fire, where(:status => [StatusCodes['外出'], StatusCodes['战斗']])
  scope :fire,   where(:status => StatusCodes['战斗'])
  # 外出 + 战斗 + 返回
  scope :w_r_f,  where(:status => [StatusCodes['外出'], StatusCodes['战斗'], StatusCodes['返回']])
  
  # 参加攻击的长枪兵
  def cqb_soliders
    soliders.live.cqb
  end

  # 参加攻击的弓箭手
  def gjs_soliders
    soliders.live.gjs
  end

  # 参加攻击的骑兵
  def qb_soliders
    soliders.live.qb
  end

  # 牺牲的长枪兵
  def dead_cqb_soliders
    soliders.dead.cqb
  end

  # 牺牲的弓箭手
  def dead_gjs_soliders
    soliders.dead.gjs
  end

  # 牺牲的骑兵
  def dead_qb_soliders
    soliders.dead.qb
  end

  # 可读状态
  def h_status
    CodeToStatus[status]
  end

  # 攻击距离
  def distance
    @distance ||= origin_city.distance_to(target_city)
  end

  # 队伍行进速度，每分钟即60s，没有士兵的情况下，速度为0
  def speed
    return Solider::Speed['长枪兵'] if cqb_soliders.count > 0
    return Solider::Speed['弓箭手'] if gjs_soliders.count > 0
    return Solider::Speed['骑兵']   if qb_soliders.count > 0
    0
  end  

  # 队伍到达敌方城市需花费的时间，转化为整型，单位second
  def move_time
    return "NULL" if speed == 0
    @mtime ||= ((self.distance / self.speed) * 60).round
  end

  # 外出
  def walk
    Resque.enqueue_in(move_time, SenorCity::FightFire, self.id)
  end

  # 交火
  def fire
    # 双方城市士兵死亡
    soliders.live.each {|solider| black_boxing(solider)}
    target_city.soliders.live.free.each {|solider| black_boxing(solider)}
    self.update_attributes(:status => StatusCodes['战斗'])
  end

  # 黑盒
  def black_boxing(solider)
    solider.dead! if rand(100) < dead_num
  end

  # 死亡率是dead_num%
  def dead_num
    (20..90).to_a[rand(71)]
  end

  # 队伍返回
  def return
    self.update_attributes(:status => StatusCodes['返回'])
    Resque.enqueue_in(move_time, SenorCity::FightReturn, self.id)
  end

  # 队伍回到城中，需要解散士兵
  def close
    soliders.live.each {|solider| solider.live_off! }
    self.update_attributes(:status => StatusCodes['结束'])
  end

end
