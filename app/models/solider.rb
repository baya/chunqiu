# -*- coding: utf-8 -*-
class Solider < ActiveRecord::Base

  Kinds = [OpenStruct.new(:name => '长枪兵', :code => 0),
           OpenStruct.new(:name => '弓箭手', :code => 1),
           OpenStruct.new(:name => '骑兵',   :code => 2)
          ]

  Codes = {'长枪兵' => 0, '弓箭手' => 1, '骑兵' => 2}
  CodeToName = {0 => '长枪兵', 1 => '弓箭手', 2 => '骑兵'}
  Speed = {'长枪兵' => 1.5, '弓箭手' => 2, '骑兵' => 10}

  Status = {'live' => 1, 'dead' => 0}

  belongs_to :city

  scope :live, where(:status => Status['live'])
  scope :dead, where(:status => Status['dead'])
  # 没有参加攻击的士兵
  scope :free, where("fight_id is NULL")
  scope :cqb,  where(:kind => Codes['长枪兵'])
  scope :gjs,  where(:kind => Codes['弓箭手'])
  scope :qb,   where(:kind => Codes['骑兵'])
  
  class << self

    # 训练长枪兵
    def study_cqb(city_id, num)
      city = City.find(city_id)
      consume_time = 10.seconds #3.minutes * num
      consume_gold = 1 * num
      sq = SoliderQueue.create(:city_id => city.id, :solider_num => num, :solider_kind => Codes['长枪兵'])

      Resque.enqueue_in(consume_time, MediumCity::CreateCQB,
                        :city_id => city.id,
                        :sq_id   => sq.id,
                        :num     => num)
      city.decrement(:gold, consume_gold)
      city.save
    end

    # 训练弓箭手
    def study_gjs(city_id, num)
      city = City.find(city_id)
      consume_time = 12.minutes * num
      consume_gold = 3 * num
      sq = SoliderQueue.create(:city_id => city.id, :solider_num => num, :solider_kind => Codes['弓箭手'])

      Resque.enqueue_in(consume_time, MediumCity::CreateGJS,
                        :city_id => city.id,
                        :sq_id   => sq.id,
                        :num     => num)
      city.decrement(:gold, consume_gold)
      city.save
    end 

    # 训练骑兵
    def study_qb(city_id, num)
      city = City.find(city_id)
      consume_time = 50.minutes * num
      consume_gold = 10 * num
      sq = SoliderQueue.create(:city_id => city.id, :solider_num => num, :solider_kind => Codes['骑兵'])

      Resque.enqueue_in(consume_time, MediumCity::CreateQB,
                        :city_id => city.id,
                        :sq_id   => sq.id,
                        :num     => num
                        )
      city.decrement(:gold, consume_gold)
      city.save
    end

  end

  # 士兵死亡
  def dead!
    update_attributes(:status => Solider::Status['dead'])
  end  

  # 参加攻击
  def attend_fight!(fight)
    self.update_attributes(:fight_id => fight.id)
  end

  # 离开队伍
  def live_off!
    self.update_attributes(:fight_id => nil)
  end
  
end
