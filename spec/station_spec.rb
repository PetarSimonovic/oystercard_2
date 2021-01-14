require 'station'

describe Station do
  subject { described_class.new }
  let(:station) { described_class.new("Mile End", 2) }

  it 'returns a stations name' do
    expect(station.name).to eq("Mile End")
  end

  it 'returns the stations zone' do
    expect(station.zone).to eq(2)
  end
end
