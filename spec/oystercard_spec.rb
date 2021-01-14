require 'oystercard'

describe OysterCard do
  subject { described_class.new }
  let(:topped_up_card) { described_class.new(OysterCard::CARD_LIMIT) }
  let(:station) { double :station }
  let(:station_out) { double :station_out }
  # let(:journey) { {entry_station: station, exit_station: station_out} }

  describe '#top_up without min fare' do

    it "does not touch in unless balance has minimum fare" do
      expect{ subject.touch_in(station) }.to raise_error "Not enough money on card"
    end
  end

  it { is_expected.to respond_to(:balance) }

  describe 'initialization' do

    it 'has a numeric balance' do
      expect(subject.balance).to be_an(Numeric)
    end

  end

  describe '#top_up' do
    it 'increases the balance with the amount passed as an argument' do
      subject.top_up(OysterCard::MINIMUM_FARE)
      expect(subject.balance).to eq(OysterCard::MINIMUM_FARE)
    end

    it "raises an exception when the new balance exceeds the limit" do
      expect { topped_up_card.top_up(OysterCard::MINIMUM_FARE) }.to raise_error "Card limit of £#{OysterCard::CARD_LIMIT} reached"
    end
  end

  describe 'touch in' do

    it { is_expected.to respond_to(:touch_in).with(1).argument }

    it "remembers the entry station" do
      topped_up_card.touch_in(station)
      expect(topped_up_card.entry_station).to eq station
    end

    it "stores the entry_station after touch in" do
      topped_up_card.touch_in("Cockfosters")
      expect(topped_up_card.journey_history).to include(:entry_station => "Cockfosters")
    end

  end

  describe '#touch out' do
    before do
      topped_up_card.touch_in(station)
    end

    it 'responds to one argument' do
      expect(topped_up_card).to respond_to(:touch_out).with(1).argument
    end

    it 'it deduct the minimum fare after touch out' do
      expect { topped_up_card.touch_out(station_out) }.to change{ topped_up_card.balance }.by(-1)
    end

    it "forgets the entry_station at touch out" do
      topped_up_card.touch_out(station_out)
      expect(topped_up_card.entry_station).to be nil
    end

    it "records the exit station at touch out in journey_history" do
      topped_up_card.touch_in(station)
      topped_up_card.touch_out("London Bridge")
      expect(topped_up_card.journey_history).to include(:exit_station => "London Bridge")
    end

  end

  # describe 'states if in journey or not' do
  #
  #   it "it is in journey after touch in" do
  #     topped_up_card.touch_in(station)
  #     expect(topped_up_card).to be_in_journey
  #   end
  #
  #   it "it is not in journey after touch out" do
  #     topped_up_card.touch_in(station)
  #     topped_up_card.touch_out(station_out)
  #     expect(topped_up_card).not_to be_in_journey
  #   end
  #
  #   it "records an entire journey" do
  #     topped_up_card.touch_in(station)
  #     topped_up_card.touch_out(station_out)
  #     expect(topped_up_card.journey_history).to eq(journey)
  #   end
  # 
  # end

end
