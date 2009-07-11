require 'rubygems'

gem 'rspec'

root_folder = File.join(File.dirname(__FILE__), '..')
lib_folder = File.join(root_folder, 'lib')
spec_folder = File.join(root_folder, 'spec')

$LOAD_PATH << lib_folder
$LOAD_PATH << spec_folder

FAKE_DATA_WIDTH = 4
FAKE_ZERO_WIDTH = -2 # just for easy identification

FAKE_RECT_DATA = [
  -1,-1,-1, 0,
  -1, 0,-1, 0,
  -1,-1,-1, 0,
   0, 0, 0, 0,
]

FAKE_DIAGONAL_DATA = [
  -1, 0, 0, 0,
   0,-1, 0, 0,
   0, 0,-1, 0,
   0, 0, 0,-1,
]

FAKE_EMPTY_DATA = [
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
]

class FakeData
  attr_reader :width
  attr_reader :height
  def initialize(data, width)
    @data = data
    @width = width
    @height = @data.length / width
  end
  def [](index)
    @data[index]
  end
end

class FakeSplicer
  attr_reader :char_width
  attr_reader :char_height
  def initialize(char_size = FAKE_DATA_WIDTH)
    @char_width = char_size
    @char_height = char_size
  end
  def zero_width
    FAKE_ZERO_WIDTH
  end
end
