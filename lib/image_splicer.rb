require 'char_data'

class ImageSplicer

  def initialize(image, cells_per_row, cells_per_column)
    @image = image
    @cells_per_row = cells_per_row
    @cells_per_column = cells_per_column
    @image_width = @image.width
    @image_height = @image.height
    @cell_width = @image_width / @cells_per_row
    @cell_height = @image_height / @cells_per_column
    validate_image_size!
  end

  def share_buffer(shared_buffer)
    @shared_buffer = shared_buffer
  end

  def validate_image_size!
    raise "bad image width: #{@image_width}" if @image_width != @cells_per_row * @cell_width
    raise "bad image height: #{@image_height}" if @image_height != @cells_per_column * @cell_height
  end

  def number_of_characters
    @cells_per_row * @cells_per_column
  end
      
  def x_from_index(index)
    index % @cells_per_row
  end
      
  def y_from_index(index)
    index / @cells_per_row
  end

  def each(&block)
    0.upto(number_of_characters - 1) do |index|
      yield data_by_index(index)
    end
  end

  def data_by_index(index)
    x = x_from_index index
    y = y_from_index index
    data_by_cell x, y
  end

  def data_by_cell(x, y)
    x_pos = x * @cell_width
    y_pos = y * @cell_height
    data = @image.get_rgb x_pos, y_pos, @cell_width, @cell_height, @shared_buffer, 0, @cell_width
    CharData.new self, data
  end

  def char_width
    @cell_width
  end

  def char_height
    @cell_height
  end

  def zero_width
    @cell_width * 2 /3
  end

  def char_offset
    return 1 if char_width < 8
    return char_width / 8
  end

end
