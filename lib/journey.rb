require_relative 'oystercard'

class Journey

  attr_reader :entry_station, :start, :journey
  attr_accessor :exit_station

  def initialize(station)
    @journey = station
  end

  def start
    @journey
  end

  def end(exit_station)
    puts "Journey started #{exit_station}"
    @exit_station = exit_station
    @journey_history << @journey
  end

  def calculate_fare
  end

end
