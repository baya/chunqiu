# -*- coding: utf-8 -*-
class SoliderQueue < ActiveRecord::Base

  belongs_to :city

  Codes = {'等待' => 0, '完成' => 1, '放弃' => -1}

  def solider_kind_name
    Solider::CodeToName[solider_kind]    
  end

  # 取消训练队列
  def remove_delayed
    Resque.remove_delayed(get_queue_class, :sq_id => self.id)
  end

  def get_queue_class
    case solider_kind
    when Solider::Codes['长枪兵']; MediumCity::CreateCQB
    when Solider::Codes['弓箭手']; MediumCity::CreateGJS
    when Solider::Codes['骑兵']; MediumCity::CreateQB
    end  
  end

  # 撤销训练后，退金子
  def gold_needed_return
    gold = case solider_kind
    when Solider::Codes['长枪兵']; 1
    when Solider::Codes['弓箭手']; 3
    when Solider::Codes['骑兵']; 10
    end  
    total_gold = gold * solider_num
  end

  def return_gold
    gold_num = gold_needed_return
    city.increment(:gold, gold_num )
    city.save
  end
  
end
