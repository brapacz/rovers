module Rover
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

end
