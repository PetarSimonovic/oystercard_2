require_relative "station"
require_relative "journey"

class OysterCard

  CARD_LIMIT = 90
  MINIMUM_FARE = 1
  DEFAULT_BALANCE = 0

  attr_reader :balance, :entry_station, :journey_history, :journey, :exit_station

  private
  attr_writer :balance

  public
  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @entry_station = nil
    @exit_station = nil
    @journey_history = {
      entry_station: @entry_station,
      exit_station: @exit_station
    }
    @journey = nil

  end

  def top_up(amount)
    fail "Card limit of £#{CARD_LIMIT} reached" if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Not enough money on card" if @balance < MINIMUM_FARE
    # @entry_station = station
    # @journey_history[:entry_station] = @entry_station
    @journey = Journey.new(station)
  
  end

   def touch_out(station_out)
    journey.end(station_out)
    @exit_station = station_out
    deduct(amount = MINIMUM_FARE)
    @journey_history[:exit_station] = @exit_station
    @entry_station = nil
  end

  def in_journey?
    @entry_station
  end

  def balance_check
  end

  private
  def limit_exceeded?(amount)
    balance + amount > CARD_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end

end
