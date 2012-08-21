春秋
====

数据库用的是Postgresql
后台任务处理用的是redis + resque + resque-scheduler
后台任务分为两种，一种是schedule job, 另一种是delayed job
以固定的频率生产粮食，每小时对所有'金子'征税等，这些都是循环执行的，属于schedule job
玩家训练一批士兵，这批士兵会在将来的某个时刻训练好，这个属于delayed job

数据模型
-------

User(玩家)

City(城市) 分为首都和普通城市两各类型

Solider(士兵) 有长枪兵，弓箭手，骑兵三种类型

SoliderQueue(士兵训练队列)

Fight(进攻)

详细的数据库表结构可以在 db/schema.rb找到

简单城市
-------

粮食生产，征税以及人口变更的代码都写在 lib/simple_city.rb文件

增加城市，查询城市当前的食物，金子，人口和税率状况的代码在 app/controllers/cities_controller.rb文件里

改变城市税率，改变玩家首都的代码写在 app/controllers/cities_controller.rb文件里


中等城市
-------

各类士兵培训以及粮食消耗的代码写在 lib/medium_city.rb文件

为一座城市增加一批新的训练士兵任务的代码写在 app/controllers/soliders_queues_controller.rb

取消排队中的训练士兵的任务的代码写在 app/controllers/soliders_queues_controller.rb

查询士兵数量和受训士兵队列的代码如下:
    
	# 长枪兵的数量
	city.cqb_soliders.count
	
	# 弓箭手的数量
	city.gjs_soliders.count
	
	# 骑兵的数量
	city.qb_soliders.count
	
	# 查询受训的队列
    city.waiting_solider_queues
	
高级城市
-------

进攻队伍移动，交战，返回的代码写在 lib/senor_city.rb 和 app/models/fight.rb 等文件中

派遣士兵攻击另外一个玩家的城市的功能代码写在 app/controllers/fights_controoler.rb文件中

    # 100个长枪兵，50个弓箭手，30个骑兵向id为6的目标城市发起进攻
    @fight = @city.create_a_fight({'cqb_num' => 100,
	                               'gjs_num' => 50,
								   'qb_num'  => 30,
								   'target_city_id' => 6
								   })
								   
    # app/models/fight.rb
	# 将交战job压入到resque队列中，出发时间由两城市间的距离和队伍行军速度决定
    def walk
      Resque.enqueue_in(move_time, SenorCity::FightFire, self.id)
    end

								   
在 app/models/city.rb文件中可以看到 create_a_fight的具体实现(在119行处)

用黑盒子功能决定幸存者和战利品，这块的代码是在 app/models/fight.rb文件中实现的(91行处)

     # 决定士兵生或者死的黑盒子
     def black_boxing(solider)
	   solider.dead! if rand(100) < dead_num
	 end
	 
玩家的城市能够显示战争的状态:

    # 可以得到所有外出和返回的进攻队伍
    @city.fights.w_r_f
	
	# 进攻队伍的详细情况
	@city.fights.w_r_f.each do |fight|
	  fight.target_city.name        # 目标城市
	  fight.distance                # 进攻距离
	  fight.move_time               # 行军时间
	  fight.h_status                # 进攻状态(外出，战斗，返回，回城)
	  fight.cqb_soliders.count      # 幸存的长枪兵数量
	  fight.gjs_soliders.count      # 幸存的弓箭手数量
	  fight.qb_soliders.count       # 幸存的骑兵数量
	  fight.dead_cqb_soliders.count # 牺牲的长枪兵数量
	  fight.dead_gjs_soliders.count # 牺牲的弓箭手数量
	  fight.dead_qb_soliders.count  # 牺牲的骑兵数量
	end
	 
入侵警告

    # 判断城市是否受到攻击
    city.be_attacked?
	
    def be_attacked?
      attacked_fights.walk_fire.count > 0
    end  

