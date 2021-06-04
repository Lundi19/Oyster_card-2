require 'oystercard'

describe Oystercard do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  context 'adding money to the card' do
    it 'returns 0 when you ask for the initial balance' do
      expect(subject.balance).to eq 0
    end
    
    it 'has an initial balance of 0 automagically' do
      expect(subject).to have_attributes(:balance => 0)
    end
  end

  context '#top_up' do

    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'should give us balance after topping up' do
      expect { subject.top_up(20) }.to change { subject.balance }.by 20
    end 

    it 'raises an error if balance exceeds the default maximum balance' do
      max_bal = Oystercard::MAXIMUM_BALANCE
      subject.top_up(max_bal)
      expect { subject.top_up(1) }.to raise_error "Balance exceeds #{max_bal}"
    end
  end

  context '#in_journey?' do
    it 'defaults to false' do
      expect(subject).not_to be_in_journey
    end
  end

  context '#touch_in, #touch_out' do
    
    before do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it { is_expected.to respond_to(:touch_in) }

    let(:station){ double :station }

    it 'stores the entry station' do
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end

    it "touches in user" do
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it { is_expected.to respond_to(:touch_out) }

    it 'touches out the user' do
      subject.touch_in(entry_station)
      expect{ subject.touch_out(station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
      expect(subject).not_to be_in_journey
    end
  end

  it 'has an empty list of journeys by default' do
    expect(subject.journeys).to be_empty
  end

  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it 'stores a journey' do
    subject.top_up(20)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include journey
  end

  context 'checks minimum balance at touch in' do
    it 'raises n error when touching in without minimum balance' do
      expect { subject.touch_in(subject)}.to raise_error "Insufficient funds"
    end
  end  
end
