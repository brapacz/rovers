module Rover
  class Error < StandardError; end

  class Position < Struct.new(:x, :y, :direction)
    NORTH = 'N'.freeze
    SOUTH = 'S'.freeze
    EAST  = 'E'.freeze
    WEST  = 'W'.freeze

    DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze

    def north?
      direction == NORTH
    end

    def south?
      direction == SOUTH
    end

    def west?
      direction == WEST
    end

    def east?
      direction == EAST
    end

    def turn_left
      turn -1
      self
    end

    def turn_right
      turn +1
      self
    end

    def move_forward
      case
      when north?
        self.y += 1
      when south?
        self.y -= 1
      when east?
        self.x += 1
      when west?
        self.x -= 1
      end
      self
    end

    def self.build(input)
      match = /^(\d)+ (\d) ([NSWE])$/.match(input)
      raise StandardError, 'wrong input format' unless match
      new(*match.to_a.drop(1).map { |value| /^\d+$/ =~ value ? value.to_i : value })
    end

    private

    def turn(index)
      current_direction = DIRECTIONS.index(direction)
      self.direction = DIRECTIONS[(current_direction+index) % DIRECTIONS.size]
    end
  end

  class Platenau < Struct.new(:max_width, :max_height)
    def include?(point)
      point.x >= 0 && point.y >= 0 && point.x <= max_width && point.y <= max_height
    end

    def self.build(input)
      match = /^(\d)+ (\d)+$/.match(input)
      raise StandardError, 'wrong input format' unless match
      new(*match.to_a.drop(1).map { |value| /^\d+$/ =~ value ? value.to_i : value })
    end
  end

  class Vehicle < Struct.new(:position, :platenau, :path)
    def move
      path.each_char do |char|
        case char
        when TURN_LEFT
          position.turn_left
        when TURN_RIGHT
          position.turn_right
        when MOVE_FORWARD
          position.move_forward
        end
      end
      self
    end

    def where
      "#{position.x} #{position.y} #{position.direction}"
    end

    TURN_LEFT    = 'L'.freeze
    TURN_RIGHT   = 'R'.freeze
    MOVE_FORWARD = 'M'.freeze
  end

  class Parser < Struct.new(:input)
    def parse
      lines    = input.split("\n")
      platenau = Platenau.build(lines.shift)
      vehicles = []
      while lines.any?
        position = Position.build(lines.shift)
        path     = lines.shift
        vehicles << Vehicle.new(position, platenau, path)
      end
      Container.new vehicles
    end
  end

  class Container < Struct.new(:vehicles)
    def move_all
      vehicles.each(&:move)
      self
    end

    def where
      vehicles.map(&:where).join("\n")
    end
  end

  def self.calculate(input)
    Parser.new(input).parse.move_all.where
  end
end
