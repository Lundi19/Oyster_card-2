class Oystercard 
  attr_reader :balance, :entry_station, :journeys
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 5

  def initialize
    @balance = 0
    # @in_journey = false
    @entry_station = nil
    @journeys = []
    @counter = 0
  end

  def top_up(amount)
    raise "Balance exceeds #{MAXIMUM_BALANCE}" if exceeds_max?(amount)

    @balance += amount
  end

  def in_journey?
    !!entry_station 
  end

  def touch_in(station)
    raise "Insufficient funds" if has_min_balance?
    @entry_station = station
    @journeys.push(entry_station: station)
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @in_journey = false
    @exit_station = station
    @journeys[@counter][:exit_station] = station
    @counter += 1
    @entry_station = nil

  end

  private

  def deduct(amount)
    raise "Insufficient funds" if enough_funds?(amount)
    @balance -= amount
  end

  def has_min_balance?
    @balance < MINIMUM_BALANCE
  end  

  def exceeds_max?(amount)
    amount + @balance > MAXIMUM_BALANCE
  end 

  def enough_funds?(amount)
    amount > @balance
  end
  
end

