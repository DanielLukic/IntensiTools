require 'bfm/char_grid_configuration'

module BFM

  import java.awt.Color
  import java.awt.Font
  import java.awt.GraphicsEnvironment
  import java.awt.Toolkit
  import java.awt.font.FontRenderContext
  import java.awt.geom.Rectangle2D
  import java.awt.image.BufferedImage

  class FontRenderer

    def initialize
      temp_image = BufferedImage.new(32, 32, BufferedImage::TYPE_INT_ARGB)
      @font_render_context = temp_image.create_graphics.font_render_context

      toolkit = Toolkit.default_toolkit
      @rendering_hints = toolkit.get_desktop_property("awt.font.desktophints")

      @char_buffer = Java::char[1].new
    end

    def available_font_names
      environment = GraphicsEnvironment.local_graphics_environment
      environment.available_font_family_names
    end

    def render_available_fonts(font_size)
      available_font_names.map { |name| render_font_name(name, font_size) }
    end

    def render_font_name(font_name, font_size, color = Color::BLACK)
      font = make_font(font_name, font_size )
      bounds = font.get_string_bounds(font_name, @font_render_context)
      image = create_image(bounds.width, bounds.height)
      graphics = image.create_graphics
      graphics.set_color color
      graphics.set_font font
      graphics.add_rendering_hints @rendering_hints if @rendering_hints
      graphics.draw_string font_name, 0, -bounds.y
      image
    end

    def make_font(font_name, font_size)
      Font.new(font_name, Font::PLAIN, font_size)
    end

    def create_image(image_width, image_height)
      BufferedImage.new(image_width, image_height, BufferedImage::TYPE_INT_ARGB)
    end

    def setup_antialiasing(graphics)
      graphics.add_rendering_hints @rendering_hints if @rendering_hints
    end

    def draw_char_grid(graphics, grid_config)
      font = graphics.font
      context = graphics.font_render_context
      offset = grid_config.cell_offset
      cell_size = grid_config.cell_size
      grid_config.each_cell do |cell|
        @char_buffer[ 0 ] = cell.char_code
        bounds = font.get_string_bounds(@char_buffer, 0, 1, context)
        x = offset.left + cell.x - bounds.x
        y = offset.top + cell.y - bounds.y
        graphics.set_clip cell.x, cell.y, cell_size.width, cell_size.height
        graphics.draw_chars @char_buffer, 0, 1, x, y
      end
      graphics.set_clip 0, 0, grid_config.grid_full_width, grid_config.grid_full_height
    end

  end

end
