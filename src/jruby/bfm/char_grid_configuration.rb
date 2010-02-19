module BFM

  import java.awt.Color
  import java.awt.Font

  class CharGridConfiguration

    DEFAULT_CELL_SIZE = 16
    DEFAULT_COLUMNS = 16
    DEFAULT_ROWS = 8
    DEFAULT_FIRST_CHAR_CODE = 32

    attr_accessor :cell_size, :cell_offset
    attr_accessor :columns, :rows
    attr_accessor :first_char_code

    def initialize
      @cell_size = CellSize.new(DEFAULT_CELL_SIZE)
      @cell_offset = CellOffset.new
      @columns = DEFAULT_COLUMNS
      @rows = DEFAULT_ROWS
      @first_char_code = DEFAULT_FIRST_CHAR_CODE
    end

    def grid_full_width
      cell_size.width * columns
    end

    def grid_full_height
      cell_size.height * rows
    end

    def each_cell(&block)
      0.upto(columns * rows - 1) do |index|
        yield Cell.new(index, self)
      end
    end

  end


  class Cell

    attr_reader :column, :row, :x, :y, :char_code

    def initialize(index, configuration)
      @configuration = configuration
      @column = index % configuration.columns
      @row = index / configuration.columns
      @x = @column * configuration.cell_size.width
      @y = @row * configuration.cell_size.height
      @char_code = index + configuration.first_char_code
    end

    def width
      @configuration.cell_size.width
    end

    def height
      @configuration.cell_size.height
    end

  end


  class CellSize

    attr_accessor :width, :height

    def initialize(initial_size)
      @width = @height = initial_size
    end

  end


  class CellOffset

    attr_accessor :top, :left, :right, :bottom

    def initialize
      @top = @left = @right = @bottom = 0
    end

  end

end
