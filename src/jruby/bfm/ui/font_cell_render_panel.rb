module BFM

  module UI

    import javax.swing.JPanel
    import java.awt.Dimension
    import java.awt.geom.Rectangle2D
    import java.awt.image.BufferedImage
    import java.util.logging.Logger

    class FontCellRenderPanel < JPanel

      include java.awt.event.KeyListener
      include java.awt.event.MouseMotionListener
      include java.awt.event.MouseWheelListener

      def initialize(controller, renderer)
        super()

        @controller = controller
        @renderer = renderer

        @controller.add_settings_changed_listener(self)

        add_mouse_motion_listener self
        add_mouse_wheel_listener self
        add_key_listener self
        set_focusable true
      end

      # MouseMotionListener

      def mouseDragged(e)
        @controller.process_scroll_event e
      end

      def mouseMoved(e)
      end

      # MouseWheelListener

      def mouseWheelMoved(e)
        @controller.process_wheel_event e
      end

      # From KeyListener

      def keyTyped(e)
        @controller.process_key_event e
      end

      def keyPressed(e)
      end

      def keyReleased(e)
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
        set_size @render_width, @render_height
        set_preferred_size Dimension.new(@render_width, @render_height)
      end

      # From JComponent

      def paintComponent( g )
        super
        on_settings_changed nil, nil unless @buffer
        g.draw_image @buffer, 0, 0, @render_width, @render_height, nil
      end

      # Implementation

      private

      def update_settings
        @zoom = @controller.zoom
        @show_raster = @controller.show_raster
        @show_offset = @controller.show_offset

        @grid_config = @controller.char_grid_configuration

        @cell_size = @grid_config.cell_size
        @cell_offset = @grid_config.cell_offset
        @grid_columns = @grid_config.columns
        @grid_rows = @grid_config.rows
        @cell_raster_width = @cell_size.width * @grid_columns
        @cell_raster_height = @cell_size.height * @grid_rows

        @render_width = @cell_raster_width * @zoom
        @render_height = @cell_raster_height * @zoom
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
        @buffer_graphics.color = @controller.background_color
        @buffer_graphics.fill_rect 0, 0, width, height
      end

      def draw_cell_raster
        @buffer_graphics.color = @controller.raster_color
        @grid_config.each_cell do |cell|
          @buffer_graphics.draw_line cell.x, cell.y, cell.x + cell.width - 1, cell.y
          @buffer_graphics.draw_line cell.x, cell.y, cell.x, cell.y + cell.height - 1
        end
      end

      def draw_font_chars
        @buffer_graphics.color = @controller.font_color
        @renderer.draw_char_grid @buffer_graphics, @grid_config
      end

    end

  end

end
