# -*- coding: utf-8 -*-
class FightsController < ApplicationController

  before_filter :authenticate_user
  before_filter :find_city
  
  
  def new
    @fight = Fight.new
    @target_cities = current_user.target_cities
  end

  # 最多同时有5批进攻+返回的部队
  def create
    if @city.fights.w_r_f.count < 5
      @fight = @city.create_a_fight(params[:fight])
      @fight.walk if @fight
    end  
    if !@fight
      flash['noitce'] = '发动进攻失败'
    end
    redirect_to :action => 'new'
  end

  private
  
  def find_city
    @city = current_user.cities.find(params[:city_id])
  end

  
end
