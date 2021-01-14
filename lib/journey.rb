require_relative 'oystercard'

class Journey

  attr_reader :entry_station
  attr_accessor :exit_station

  def initialize(entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  
end
