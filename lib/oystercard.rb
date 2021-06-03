class Oystercard 
  attr_reader :balance, :entry_station, :list_of_journeys
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 5

  def initialize
    @balance = 0
    # @in_journey = false
    @entry_station = nil
    @list_of_journeys = []
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
    @list_of_journeys.push({@entry_station => ''})
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @in_journey = false
    @exit_station = station
    @list_of_journeys[0][@entry_station] = @exit_station
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