require 'rspec'
require 'rspec/its'

require_relative 'rover'

describe Rover::Position do
  subject { position }

  let(:position)  { described_class.new(start_x, start_y, start_dir) }
  let(:start_x)   { 0 }
  let(:start_y)   { 0 }
  let(:start_dir) { north }
  let(:north)     { described_class::NORTH }
  let(:south)     { described_class::SOUTH }
  let(:east)      { described_class::EAST }
  let(:west)      { described_class::WEST }

  its(:x)         { is_expected.to be_eql start_x }
  its(:y)         { is_expected.to be_eql start_y }
  its(:direction) { is_expected.to be_eql north }

  describe 'when direction is "north"' do
    let(:start_dir) { north }
    it { is_expected.to_not be_south }
    it { is_expected.to_not be_east }
    it { is_expected.to_not be_west }
    it { is_expected.to be_north }
  end

  describe 'when direction is "south"' do
    let(:start_dir) { south }
    it { is_expected.to_not be_north }
    it { is_expected.to_not be_east }
    it { is_expected.to_not be_west }
    it { is_expected.to be_south }
  end

  describe 'when direction is "west"' do
    let(:start_dir) { west }
    it { is_expected.to_not be_north }
    it { is_expected.to_not be_south }
    it { is_expected.to_not be_east }
    it { is_expected.to be_west }
  end

  describe 'when direction is "east"' do
    let(:start_dir) { east }
    it { is_expected.to_not be_north }
    it { is_expected.to_not be_south }
    it { is_expected.to_not be_west }
    it { is_expected.to be_east }
  end


  describe '#move_forward' do
    before  { position.move_forward }

    context 'when it is heading north' do
      let(:start_dir) { north }
      its(:x) { is_expected.to be_eql start_x }
      its(:y) { is_expected.to be_eql start_y+1 }
    end

    context 'when it is heading west' do
      let(:start_dir) { west }
      its(:x)         { is_expected.to be_eql start_x-1 }
      its(:y)         { is_expected.to be_eql start_y }
    end

    context 'when it is heading south' do
      let(:start_dir) { south }
      its(:x)         { is_expected.to be_eql start_x }
      its(:y)         { is_expected.to be_eql start_y-1 }
    end

    context 'when it is heading east' do
      let(:start_dir) { east }
      its(:x)         { is_expected.to be_eql start_x+1 }
      its(:y)         { is_expected.to be_eql start_y }
    end
  end

  describe '#turn_left' do
    before { position.turn_left }

    its(:x)         { is_expected.to be_eql start_x }
    its(:y)         { is_expected.to be_eql start_y }
    its(:direction) { is_expected.to be_eql west }

    context 'when it is heading west' do
      let(:start_dir) { west }
      its(:direction) { is_expected.to be_eql south }
    end

    context 'when it is heading south' do
      let(:start_dir) { south }
      its(:direction) { is_expected.to be_eql east }
    end

    context 'when it is heading east' do
      let(:start_dir) { east }
      its(:direction) { is_expected.to be_eql north }
    end
  end

  describe '#turn_right' do
    before { position.turn_right }

    its(:x)         { is_expected.to be_eql start_x }
    its(:y)         { is_expected.to be_eql start_y }
    its(:direction) { is_expected.to be_eql east }

    context 'when it is heading east' do
      let(:start_dir) { east }
      its(:direction) { is_expected.to be_eql south }
    end

    context 'when it is heading south' do
      let(:start_dir) { south }
      its(:direction) { is_expected.to be_eql west }
    end

    context 'when it is heading west' do
      let(:start_dir) { west }
      its(:direction) { is_expected.to be_eql north }
    end
  end
end

describe Rover::Platenau do
  subject { platenau }

  let(:start_width)  { 5 }
  let(:start_height) { 5 }
  let(:platenau)     { described_class.new(start_width, start_height)}

  describe '#include?' do
    it { is_expected.to be_include position(1, 1) }
    it { is_expected.to be_include position(start_width-1, start_height-1) }

    it { is_expected.to_not be_include position(start_width, start_height) }
    it { is_expected.to_not be_include position(start_width+1,start_height+1) }
    it { is_expected.to_not be_include position(start_width+1,-1) }
    it { is_expected.to_not be_include position(-1,start_height+1) }
    it { is_expected.to_not be_include position(-1,1) }
    it { is_expected.to_not be_include position(start_width+1,start_height+1) }
    it { is_expected.to_not be_include position(start_width+1,-1) }
    it { is_expected.to_not be_include position(-1,start_height+1) }
  end

  private

  def position(x,y)
    Rover::Position.new(x,y,Rover::Position::DIRECTIONS.sample)
  end
end

describe Rover do
  let(:rover)       { described_class.new(position, platenau, path) }
  let(:position)    { double(:position, x: start_x, y: start_y, direction: direction) }
  let(:start_x)     { (1...width).to_a.sample }
  let(:start_y)     { (1...height).to_a.sample }
  let(:direction)   { Rover::Position::NORTH }
  let(:width)       { 5 }
  let(:height)      { 5 }
  let(:platenau)    { double(:platenau, include?: is_included) }
  let(:is_included) { true }
  let(:path)        { 'LML' }

  describe '#move' do
    before { rover.move }
    its(:x) { is_expected.to be_eql start_x-1 }
    its(:y) { is_expected.to be_eql start_y }
    it      { is_expected.to be_south }
  end
end
