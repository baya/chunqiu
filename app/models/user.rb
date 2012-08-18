class User < ActiveRecord::Base
  has_many :cities

  validates_presence_of   :name
  validates_uniqueness_of :name

  
  def disable_other_capital(capital_city)
    self.cities.where(:capital => true).each {|city|
      next if capital_city == city
      city.update_attributes(:capital => false)
    }
  end
  
end
