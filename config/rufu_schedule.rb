require 'rufus/scheduler'
require 'eventmachine'

EM.run {
  scheduler = Rufus::Scheduler.start_new

  scheduler.every '3s' do
    puts 'check blood pressure'
  end
  
}
