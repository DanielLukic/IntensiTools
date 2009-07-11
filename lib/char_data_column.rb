class CharDataColumn

  ALPHA_MASK = 0xFF000000;

  attr_reader :index

  def initialize(data, index)
    @data = data
    @index = index
  end

  def has_non_zero_alpha_value
    0.upto(@data.height - 1) do |y|
      data_pos = @index + y * @data.width
      alpha_value = @data[data_pos] & ALPHA_MASK;
      return true if alpha_value != 0
    end
    false
  end

end
