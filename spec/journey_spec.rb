require 'journey'

describe Journey do
  subject { described_class.new }
  let(:entry_station) { double :entry_station}
  let(:exit_station) { double :exit_station}

  it 'returns an entry station' do
    expect(subject.entry_station(entry_station)).to eq entry_station
  end

  it 'returns an exit station' do
    expect(subject.exit_station(exit_station)).to eq exit_station
  end
end
