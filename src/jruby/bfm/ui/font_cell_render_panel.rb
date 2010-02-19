module BFM

  module UI

    import javax.swing.JPanel
    import java.awt.Dimension
    import java.awt.geom.Rectangle2D
    import java.awt.image.BufferedImage
    import java.util.logging.Logger

    class FontCellRenderPanel < JPanel # implements SettingsChangedListener

      def initialize(controller, renderer)
        super()

        @controller = controller
        @renderer = renderer

        @char_buffer = Java::char[1].new

        @controller.add_settings_changed_listener(self)
      end

      # From SettingsChangedListener

      def on_settings_changed(settings_id, settings_value)
        update_settings
        update_buffer_if_necessary
        update_font_if_necessary
        clear_background
        draw_cell_raster if @show_raster
        draw_font_chars
        repaint
        set_size(@render_width, @render_height)
        set_preferred_size(Dimension.new(@render_width, @render_height))
      end

      # From JComponent

      def paintComponent( g )
        super
        on_settings_changed(nil, nil) unless @buffer
        g.draw_image(@buffer, 0, 0, @render_width, @render_height, nil)
      end

      # Implementation

      private

      def update_settings
        @zoom_factor = @controller.selected_zoom_factor
        @show_raster = @controller.selected_show_raster_flag
        @cell_size = @controller.selected_cell_size
        @cell_offset = @controller.selected_cell_offset
        @cells_per_row = @controller.selected_cells_per_row
        @cells_per_column = @controller.selected_cells_per_column
        @cell_raster_width = @cell_size * @cells_per_row
        @cell_raster_height = @cell_size * @cells_per_column
        @render_width = @cell_raster_width * @zoom_factor
        @render_height = @cell_raster_height * @zoom_factor
      end

      def update_buffer_if_necessary
        return unless new_buffer_necessary?
        @buffer = BufferedImage.new(@cell_raster_width, @cell_raster_height, BufferedImage::TYPE_INT_ARGB)
        @buffer_graphics = @buffer.create_graphics
      end

      def new_buffer_necessary?
        return @buffer.nil? || @buffer.width != @cell_raster_width || @buffer.height != @cell_raster_height
      end

      def update_font_if_necessary
        name = @controller.selected_font_name
        size = @controller.selected_font_size
        @font = @renderer.make_font(name, size) if new_font_necessary?(name, size)
        @buffer_graphics.font = @font if @buffer_graphics.font != @font
      end

      def new_font_necessary?(font_name, font_size)
        return @font.nil? || !@font.name.eql?(font_name) || @font.size != font_size
      end

      def clear_background
        @buffer_graphics.set_color(Color::WHITE)
        @buffer_graphics.fill_rect(0, 0, width, height)
      end

      def draw_cell_raster
        @buffer_graphics.set_color(Color::LIGHT_GRAY)
        0.upto(@cells_per_row - 1) do |idx|
          @buffer_graphics.draw_line(idx * @cell_size, 0, idx * @cell_size, @cell_raster_height)
        end
        0.upto(@cells_per_column - 1) do |idx|
          @buffer_graphics.draw_line(0, idx * @cell_size, @cell_raster_width, idx * @cell_size)
        end
      end

      def draw_font_chars
        @buffer_graphics.set_color(Color::BLACK)
        0.upto(@cells_per_column - 1) do |column|
          y = column * @cell_size
          0.upto(@cells_per_row - 1) do |row|
            x = row * @cell_size
            char_index = 32 + row + column * @cells_per_row
            @char_buffer[ 0 ] = char_index
            bounds = @font.getStringBounds(@char_buffer, 0, 1, @buffer_graphics.font_render_context)
            @buffer_graphics.draw_chars(@char_buffer, 0, 1, x - bounds.x, @cell_offset + y - bounds.y)
          end
        end
      end

    end

  end

end
