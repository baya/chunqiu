# -*- coding: utf-8 -*-
require 'test_helper'

class CityTest < ActiveSupport::TestCase

  test '抽税后, 人口数量小于税率 * 1000' do
    city_hash = {:name => '衡水',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 1000,
      :human => 100
    }
    city = City.create city_hash
    city.take_tax
    assert_equal city.human, 105
    assert_equal city.gold,  80
    
  end

  test '抽税后，人口数量大于税率 * 1000' do 
    city_hash = {:name => '衡水',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 1000,
      :human => 300
    }
    
    city = City.create city_hash
    city.take_tax
    assert_equal city.human, 285
    assert_equal city.gold,  80
  end

  test '抽税后，人口数量大于税率 * 1000，且人口数量 * 0.05 大于 1000' do
    
    city_hash = {:name => '衡水',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 1000,
      :human => 40000
    }
    
    city = City.create city_hash
    city.take_tax
    assert_equal city.human, 39000
    assert_equal city.gold,  80
    
  end

  test '抽税后，人口数量大于税率 * 1000，且人口数量 * 0.05 小于1' do
    
    city_hash = {:name => '衡水',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 1000,
      :human => 10
    }
    
    city = City.create city_hash
    city.take_tax
    assert_equal city.human, 11
    assert_equal city.gold,  80
    
  end

  test '有10个长枪兵，3个弓箭手，5个骑兵,那么每小时消耗食物10 * 10 + 3 * 13 + 5 * 30 ＝ 289' do
    city_hash = {
      :name  => '单庆',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
    city = City.create city_hash
    10.times {city.soliders.create(:kind => Solider::Codes['长枪兵'])}
    3.times {city.soliders.create(:kind => Solider::Codes['弓箭手'])}
    5.times {city.soliders.create(:kind => Solider::Codes['骑兵'])}
    assert_equal city.consumed_food_per_hour, 289
  end

  test '粮食危机, 各个兵种减少10%' do
    city_hash = {
      :name  => '贵林',
      :pos_x => 0,
      :pos_y => 0,
      :tax_rate => 0.2,
      :gold => 100,
      :food => -20.0,
      :human => 10
    }
    city = City.create city_hash
    cqb_num, gjs_num, qb_num = 100, 30, 50
    cqb_num.times {city.soliders.create(:kind => Solider::Codes['长枪兵'])}
    gjs_num.times {city.soliders.create(:kind => Solider::Codes['弓箭手'])}
    qb_num.times  {city.soliders.create(:kind => Solider::Codes['骑兵'])}
    city.soliders_dead_due_lacking_food
    assert_equal city.cqb_soliders.count, 90
    assert_equal city.gjs_soliders.count, 27
    assert_equal city.qb_soliders.count, 45
  end

  test '计算两城间的距离' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
   
    a_city = City.create a_city_hash
    b_city = City.create b_city_hash

    assert_equal a_city.distance_to(b_city), 559
    assert_equal b_city.distance_to(a_city), 559
    
    
  end

  test '召集长枪兵' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 100
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
    cqb_num = 10
    city = City.create(a_city_hash)
    target_city = City.create(b_city_hash)
    fight = city.fights.create(:target_city_id => target_city.id, :status => Fight::StatusCodes['外出'])
    cqb_num.times {city.soliders.create(:kind => Solider::Codes['长枪兵'])}
    city.call_cqb_soliders_to_fight(5, fight)
    assert_equal fight.cqb_soliders.count, 5
  end

  test '召集弓箭手' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 100
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
    gjs_num = 10
    city = City.create(a_city_hash)
    target_city = City.create(b_city_hash)
    fight = city.fights.create(:target_city_id => target_city.id, :status => Fight::StatusCodes['外出'])
    gjs_num.times {city.soliders.create(:kind => Solider::Codes['弓箭手'])}
    city.call_gjs_soliders_to_fight(5, fight)
    assert_equal fight.gjs_soliders.count, 5
  end

  test '召集骑兵' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 100
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }
    qb_num = 10
    city = City.create(a_city_hash)
    target_city = City.create(b_city_hash)
    fight = city.fights.create(:target_city_id => target_city.id, :status => Fight::StatusCodes['外出'])
    qb_num.times {city.soliders.create(:kind => Solider::Codes['骑兵'])}
    city.call_qb_soliders_to_fight(5, fight)
    assert_equal fight.qb_soliders.count, 5
  end

  test '发动一次进攻，成功' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 100
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }

    

    cqb_num = 20
    gjs_num = 10
    qb_num  = 5
    city = City.create(a_city_hash)
    target_city = City.create(b_city_hash)
    cqb_num.times {city.soliders.create(:kind => Solider::Codes['长枪兵'])}
    gjs_num.times {city.soliders.create(:kind => Solider::Codes['弓箭手'])}
    qb_num.times {city.soliders.create(:kind => Solider::Codes['骑兵'])}
    fight_hash  = {'cqb_num' => 10, 'gjs_num' => 5, 'qb_num' => 2, 'target_city_id' => target_city.id}
    fight = city.create_a_fight(fight_hash)
    assert_equal fight.cqb_soliders.count, 10
    assert_equal fight.gjs_soliders.count, 5
    assert_equal fight.qb_soliders.count, 2
    
  end

  test '发动一次进攻，由于兵力不够失败' do
    a_city_hash = {
      :name  => '短沙',
      :pos_x => 100,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 100
    }
    b_city_hash = {
      :name  => '菊户',
      :pos_x => 800,
      :pos_y => 50,
      :tax_rate => 0.2,
      :gold => 100,
      :food => 10000,
      :human => 10
    }

    cqb_num = 2
    gjs_num = 10
    qb_num  = 5
    city = City.create(a_city_hash)
    target_city = City.create(b_city_hash)
    cqb_num.times {city.soliders.create(:kind => Solider::Codes['长枪兵'])}
    gjs_num.times {city.soliders.create(:kind => Solider::Codes['弓箭手'])}
    qb_num.times {city.soliders.create(:kind => Solider::Codes['骑兵'])}
    fight_hash  = {'cqb_num' => 10, 'gjs_num' => 5, 'qb_num' => 2, 'target_city_id' => target_city.id}
    fight = city.create_a_fight(fight_hash)
    assert_nil fight
    
  end



end
