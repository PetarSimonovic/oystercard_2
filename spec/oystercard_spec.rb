require 'oystercard'

describe OysterCard do

  let(:station) { double :station }
  let(:station_out) { double :station_out }
  let(:journey) { {entry_station: station, exit_station: station_out} }

  describe '#top_up without min fare' do

    it "does not touch in unless balance has minimum fare" do
      card = OysterCard.new
      expect{ card.touch_in(station) }.to raise_error "Not enough money on card"
    end
  end

  before do
    subject.top_up(10)
  end

  it { is_expected.to respond_to(:balance) }

  describe 'initialization' do

    it 'has a numeric balance' do
      expect(subject.balance).to be_an(Numeric)
    end

  end

  describe '#top_up' do
    it 'increases the balance with the amount passed as an argument' do
      subject.top_up(5)
      expect(subject.balance).to eq 15
    end

    it "raises an exception when the new balance exceeds the limit" do
      card = OysterCard.new
      card.top_up(OysterCard::CARD_LIMIT)
      expect { card.top_up(1) }.to raise_error "Card limit of £#{OysterCard::CARD_LIMIT} reached"
    end
  end

  describe 'deduct' do

    it 'deducts amount from the balance of the card' do
      expect{ subject.deduct(5) }.to change{ subject.balance}.by -5
    end
  end

  describe 'touch in' do

    it { is_expected.to respond_to(:touch_in).with(1).argument }

    it "remembers the entry station" do
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end

    it "stores the entry_station after touch in" do
      subject.touch_in("Cockfosters")
      expect(subject.journey_history).to include(:entry_station => "Cockfosters")
    end

  end

  describe '#touch out' do
    before do
      subject.touch_in(station)
    end

    it 'responds to one argument' do
      expect(subject).to respond_to(:touch_out).with(1).argument
    end

    it 'it deduct the minimum fare after touch out' do
      expect { subject.touch_out(station_out) }.to change{ subject.balance }.by(-1)
    end

    it "forgets the entry_station at touch out" do
      subject.touch_out(station_out)
      expect(subject.entry_station).to be nil
    end

    it "records the exit station at touch out in journey_history" do
      subject.touch_in(station)
      subject.touch_out("London Bridge")
      expect(subject.journey_history).to include(:exit_station => "London Bridge")
    end

  end

  describe 'states if in journey or not' do

    it "it is in journey after touch in" do
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it "it is not in journey after touch out" do
      subject.touch_in(station)
      subject.touch_out(station_out)
      expect(subject).not_to be_in_journey
    end

    it "records an entire journey" do
      subject.touch_in(station)
      subject.touch_out(station_out)
      expect(subject.journey_history).to eq(journey)
    end

  end

end
