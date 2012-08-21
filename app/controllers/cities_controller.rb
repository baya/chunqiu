# -*- coding: utf-8 -*-
class CitiesController < ApplicationController

  before_filter :find_user
  before_filter :authenticate_user, :except => ['new', 'index']

  def index
    @cities = @user.cities
  end  

  def show
    @city = @user.cities.find(params[:id])
    respond_to do |format|
      format.json {render :json => @city.to_json }
      format.xml {render :xml => @city.to_xml}
      format.html
    end  
  end

  def edit
    @city = @user.cities.find(params[:id])
  end

  def update
    @city = @user.cities.find(params[:id])
    @city.tax_rate = params[:city][:tax_rate]
    @city.capital = params[:city][:capital]
    if @city.save
      if @city.capital?
        # 确保玩家只有一个首都
        @user.disable_other_capital(@city)
      end  
      redirect_to user_cities_url(@user)
    else
      render 'edit'
    end  
  end  

  def new
    @city = City.new
  end

  def create
    @city = @user.cities.build(params[:city])
    @city.init_resources
    if @city.save
      Resque.enqueue_in(5.seconds, SimpleCity::CapitalProduceFood)
      redirect_to user_cities_url(@user)
    else
      render 'new'
    end  
  end  

  private

  def find_user
    @user = User.find(params[:user_id])
  end  
  
end
