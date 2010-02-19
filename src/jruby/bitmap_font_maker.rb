require 'java'

require 'bfm/font_renderer'
require 'bfm/main_frame'
require 'bfm/ui_controller'
require 'bfm/ui_builder'

controller = BFM::UiController.new
renderer = BFM::FontRenderer.new
builder = BFM::UiBuilder.new(controller, renderer)
frame = BFM::MainFrame.new(builder)
frame.center_and_resize_to(80, 80)
frame.set_visible(true)
