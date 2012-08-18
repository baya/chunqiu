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

end
