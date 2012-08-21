# -*- coding: utf-8 -*-
class SoliderQueuesController < ApplicationController

  before_filter :authenticate_user
  before_filter :find_city

  def new
  end

  # 增加一批新的训练士兵的任务
  def create
    if @city.waiting_solider_queues.count >= 5
      flash[:notice] = '等待接受训练的批次已经达到5批'
      redirect_to :action => 'new'
      return
    end
    solider = params[:solider]
    case solider[:kind].to_i
    when Solider::Codes['长枪兵']
      Solider.study_cqb(@city.id, solider[:num].to_i)
    when Solider::Codes['弓箭手']
      Solider.study_gjs(@city.id, solider[:num].to_i)
    when Solider::Codes['骑兵']
      Solider.study_qb(@city.id, solider[:num].to_i)
    end
    redirect_to :action => 'new'
  end

  # 取消士兵训练队伍，并且退换金子
  def destroy
    sq = SoliderQueue.find(params[:id])
    sq.remove_delayed
    sq.return_gold
    sq.destroy
    redirect_to :action => 'new'
  end

  private
  
  def find_city
    @city = current_user.cities.find(params[:city_id])
  end

end
