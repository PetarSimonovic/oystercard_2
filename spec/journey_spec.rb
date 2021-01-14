require 'journey'
require 'station'

describe Journey do
  let(:station) { Station.new("Mile End", 2) }
  subject { described_class.new(station) }
  # let(:entry_station) { double entry_station: entry_station }
  # let(:exit_station) { double exit_station: exit_station }

  it 'returns an entry station' do
    expect(subject.entry_station).to eq(station)
  end

  # it 'returns an exit station' do
  #   expect(subject.exit_station(exit_station)).to eq exit_station
  # end
end
