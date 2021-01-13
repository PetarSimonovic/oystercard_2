class OysterCard

  CARD_LIMIT = 90
  MINIMUM_FARE = 1

  attr_reader :balance, :entry_station, :journey_history
  attr_accessor :active

  private
  attr_writer :balance

  public
  def initialize
    @journey_history = {}
    @balance = 0
    @entry_station = false
  end

  def top_up(amount)
    fail "Card limit of £#{CARD_LIMIT} reached" if limit_exceeded?(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in(station)
    fail "Not enough money on card" if @balance < MINIMUM_FARE
    @entry_station = station
    @journey_history[:entry_station] = @entry_station
  end

  def touch_out(station)
    @entry_station = nil
    deduct(amount = MINIMUM_FARE)
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

end
