require 'char_data_column'

class CharData

  def initialize(splicer, data)
    @splicer = splicer
    @data = data
  end

  def width
    @splicer.char_width
  end

  def height
    @splicer.char_height
  end

  def columns
    (0..@splicer.char_width - 1).map do |index|
      CharDataColumn.new(self, index)
    end
  end

  def find_width
    columns.reverse.each do |column|
      return column.index + 1 if column.has_non_zero_alpha_value
    end
    return @splicer.zero_width
  end

  def [](index)
    @data[index]
  end

end
