#!/usr/bin/jruby

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'java'
require 'image_splicer'

include_class 'javax.imageio.ImageIO'
include_class 'java.io.DataOutputStream'
include_class 'java.io.FileInputStream'
include_class 'java.io.FileOutputStream'

font_file_pathes = ARGV

unless font_file_pathes
  puts "Usage: #{$0} <font_file_pathes..>"
  puts
  puts "Example: #{$0} res/GameName/*/*font.png"
  puts
  exit 5
end

def load_image(filename)
  stream = FileInputStream.new filename
  ImageIO.read stream
end

def create_splicer(buffered_image)
  splicer = ImageSplicer.new buffered_image, CELLS_PER_ROW, CELLS_PER_COLUMN
  splicer.share_buffer Java::int[splicer.char_width * splicer.char_height].new
  splicer
end

def determine_char_widths(splicer)
  widths = []
  splicer.each { |char_data| widths << char_data.find_width }
  widths
end

def apply_char_offset(splicer, char_widths)
  char_offset = splicer.char_offset
  char_widths.map! {|w| w + char_offset}
end

def make_output_filename(filename)
  filename.sub /\.png$/, '.dst'
end

def write_char_widths(filename, char_widths)
  output = DataOutputStream.new( FileOutputStream.new( filename ) )
  char_widths.each { |w| output.write_byte w }
  output.close
end

CELLS_PER_ROW = 16
CELLS_PER_COLUMN = 8

font_file_pathes.sort.each do |input_filename|
  puts "processing #{input_filename}"

  raise "file not found: #{inputFileName}" unless File.exist?(input_filename)
  
  image = load_image input_filename
  splicer = create_splicer image

  char_widths = determine_char_widths splicer
  apply_char_offset splicer, char_widths

  output_filename = make_output_filename input_filename
  write_char_widths output_filename, char_widths
end

exit 0
