class OysterCard

   CARD_LIMIT = 90
   MINIMUM_FARE = 1

    attr_reader :balance, :entry_station
    attr_accessor :active

    private
    attr_writer :balance

    public

    def initialize
        @balance = 0
        @active = false
        @entry_station = nil
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
      @active = true
    end

    def touch_out
      @active = false
      @entry_station = nil 
      deduct(amount = MINIMUM_FARE)
    end

    def in_journey?
      @active
    end

    def balance_check
    end

    private

    def limit_exceeded?(amount)
      balance + amount > CARD_LIMIT
    end

end
