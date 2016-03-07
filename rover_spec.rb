require 'rspec'
require 'rspec/its'

require_relative 'rover'

describe Rover::Position do
  subject { position }

  let(:position)  { described_class.new(start_x, start_y, start_dir) }
  let(:start_x)   { 0 }
  let(:start_y)   { 0 }
  let(:start_dir) { 'N' }

  its(:x)         { is_expected.to be_eql start_x }
  its(:y)         { is_expected.to be_eql start_y }
  its(:direction) { is_expected.to be_eql 'N' }

  describe '#move_forward' do
    before  { position.move_forward }

    context 'when it is heading north' do
      let(:start_dir) { 'N' }
      its(:x) { is_expected.to be_eql start_x }
      its(:y) { is_expected.to be_eql start_y+1 }
    end

    context 'when it is heading west' do
      let(:start_dir) { 'W' }
      its(:x)         { is_expected.to be_eql start_x-1 }
      its(:y)         { is_expected.to be_eql start_y }
    end

    context 'when it is heading south' do
      let(:start_dir) { 'S' }
      its(:x)         { is_expected.to be_eql start_x }
      its(:y)         { is_expected.to be_eql start_y-1 }
    end

    context 'when it is heading east' do
      let(:start_dir) { 'E' }
      its(:x)         { is_expected.to be_eql start_x+1 }
      its(:y)         { is_expected.to be_eql start_y }
    end
  end

  describe '#turn_left' do
    before { position.turn_left }

    its(:x)         { is_expected.to be_eql start_x }
    its(:y)         { is_expected.to be_eql start_y }
    its(:direction) { is_expected.to be_eql 'W' }

    context 'when it is heading west' do
      let(:start_dir) { 'W' }
      its(:direction) { is_expected.to be_eql 'S' }
    end

    context 'when it is heading south' do
      let(:start_dir) { 'S' }
      its(:direction) { is_expected.to be_eql 'E' }
    end

    context 'when it is heading east' do
      let(:start_dir) { 'E' }
      its(:direction) { is_expected.to be_eql 'N' }
    end
  end

  describe '#turn_right' do
    before { position.turn_right }

    its(:x)         { is_expected.to be_eql start_x }
    its(:y)         { is_expected.to be_eql start_y }
    its(:direction) { is_expected.to be_eql 'E' }

    context 'when it is heading east' do
      let(:start_dir) { 'E' }
      its(:direction) { is_expected.to be_eql 'S' }
    end

    context 'when it is heading south' do
      let(:start_dir) { 'S' }
      its(:direction) { is_expected.to be_eql 'W' }
    end

    context 'when it is heading west' do
      let(:start_dir) { 'W' }
      its(:direction) { is_expected.to be_eql 'N' }
    end
  end

end


