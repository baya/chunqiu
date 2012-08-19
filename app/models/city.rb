class City < ActiveRecord::Base
  belongs_to :user
  scope :capital_cities, where(:capital => true)
  scope :normal_cities, where(:capital => [false, nil])

  validates_presence_of :name, :food, :human, :gold, :tax_rate
  validates_numericality_of :tax_rate,
  :greater_than_or_equal_to => 0,
  :less_than_or_equal_to    => 1.0
  validates_numericality_of :food, :human, :gold, :only_integer => true

  def init_resources
    self.food     = 0
    self.human    = 100
    self.gold     = 0
    self.tax_rate = 0.2
    self.capital  = false
  end

  def take_tax
    rest_gold = gold - gold * tax_rate
    self.gold = rest_gold.to_i
    float_human = human * 0.05 >= 1000 ? 1000 : human * 0.05
    float_human = 1 if float_human < 1
    if human < tax_rate * 1000
      self.increment(:human, float_human.to_i)
    else
      self.decrement(:human, float_human.to_i)
    end
    res = save
  end

end
