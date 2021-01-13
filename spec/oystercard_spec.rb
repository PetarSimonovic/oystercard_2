require 'oystercard'

describe OysterCard do

    let(:station) { double :station }

    it { is_expected.to respond_to(:balance) }

    describe 'initialization' do

        it 'has a numeric balance' do
            expect(subject.balance).to be_an(Numeric)
        end

    end

    describe '#top_up' do

        it 'increases the balance with the amount passed as an argument' do
            subject.top_up(15)
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
        subject.top_up(15)
        expect{ subject.deduct(5) }.to change{ subject.balance}.by -5
      end
    end

    describe 'touch in' do

      it { is_expected.to respond_to(:touch_in).with(1).argument }

      it "changes active to true" do
        subject.top_up(5)
        subject.touch_in(station)
        expect(subject.active).to eq true
      end

      it "does not touch in unless balance has minimum fare" do
        expect{ subject.touch_in(station) }.to raise_error "Not enough money on card"
      end

      it "remembers the entry station" do
        subject.top_up(5)
        subject.touch_in(station)
        expect(subject.entry_station).to eq station
      end

    end

    describe ' touch out' do

      it 'changes active to false' do
        subject.top_up(5)
        subject.touch_in(station)
        subject.touch_out
        expect(subject.active).to eq false
    end

    it 'it deduct the minimum fare after touch out' do
      subject.top_up(5)
      subject.touch_in(station)
      expect { subject.touch_out }.to change{ subject.balance }.by(-1)
    end

    it "forgets the entry_station at touch out" do
      subject.touch_out
      expect(subject.entry_station).to be nil
    end

  end

  describe 'states if in journey or not' do

    it "it is in journey after touch in" do
      subject.top_up(5)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it "it is not in journey after touch out" do
      subject.top_up(5)
      subject.touch_in(station)
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
  end

end
