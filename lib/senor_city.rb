# -*- coding: utf-8 -*-
module SenorCity

  # 进攻队伍战斗
  class FightFire
    @queue = :fight

    def self.perform(fight_id)
      fight = Fight.find(fight_id)
      fight.fire
      fight.return
    end
    
  end  

  # 进攻队伍返回
  class FightReturn
    @queue = :fight

    def self.perform(fight_id)
      fight = Fight.find(fight_id)
      fight.close
    end
    
  end

end
