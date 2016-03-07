require 'rspec'
require 'rspec/its'
require 'byebug'

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

  let(:start_width)  { rand 3..10 }
  let(:start_height) { rand 3..10 }
  let(:platenau)     { described_class.new(start_width, start_height)}

  describe '#include?' do
    it { is_expected.to be_include position(1, 1) }
    it { is_expected.to be_include position(start_width-1, start_height-1) }
    it { is_expected.to be_include position(start_width, start_height) }

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
  subject { rover }

  let(:rover)       { described_class.new(position, platenau, path) }
  let(:position)    { Rover::Position.new(start_x, start_y, start_dir) }
  let(:start_x)     { (1...width).to_a.sample }
  let(:start_y)     { (1...height).to_a.sample }
  let(:start_dir)   { Rover::Position::NORTH }
  let(:width)       { 5 }
  let(:height)      { 5 }
  let(:platenau)    { Rover::Platenau.new(width, height) }
  let(:is_included) { true }
  let(:path)        { 'LMLRL' }

  its(:where) { is_expected.to be_eql "#{position.x} #{position.y} #{position.direction}" }

  describe '#move' do
    before { rover.move }

    context 'when robot start on 1 2 N and path is LMLMLMLMM' do
      let(:path)      { 'LMLMLMLMM' }
      let(:start_x)   { 1 }
      let(:start_y)   { 2 }
      let(:start_dir) { 'N' }

      its(:where) { is_expected.to be_eql '1 3 N' }
    end

    context 'when robot start on 3 3 E and path is MMRMMRMRRM' do
      let(:path)      { 'MMRMMRMRRM' }
      let(:start_x)   { 3 }
      let(:start_y)   { 3 }
      let(:start_dir) { 'E' }

      its(:where) { is_expected.to be_eql '5 1 E' }
    end
  end
end
