class Journey
  attr_reader :fare, :entry_station
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize(station=nil)
    @fare = PENALTY_FARE
    @entry_station = station
    @exit_station = nil
  end

  def finish(station)
     @exit_station = station
     self
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY_FARE 
  end


  def complete?
    @entry_station && @exit_station
  end
end