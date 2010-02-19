require 'bfm/char_grid_configuration'

module BFM

  import java.awt.event.KeyEvent
  import java.util.ArrayList

  class UiController

    SETTINGS_ID_UNKNOWN = :UNKNOWN

    INITIAL_ZOOM = 2

    def initialize
      @listeners = Array.new
      @zoom = INITIAL_ZOOM
      @show_raster = @show_offset = false
      @char_grid_configuration = BFM::CharGridConfiguration.new
      @cell_size = @char_grid_configuration.cell_size
      @cell_offset = @char_grid_configuration.cell_offset
    end

    def set_font_settings_provider(provider)
      @font_settings = provider
    end

    def set_cell_settings_provider(provider)
      @cell_settings = provider
    end

    def set_view_settings_provider(provider)
      @view_settings = provider
    end

    def process_key_event(event)
      return unless event.get_id == KeyEvent::KEY_PRESSED
      @cell_settings.adjust_cell_offset :top, -1 if event.key_code == KeyEvent::VK_UP
      @cell_settings.adjust_cell_offset :top, +1 if event.key_code == KeyEvent::VK_DOWN
      @cell_settings.adjust_cell_offset :left, -1 if event.key_code == KeyEvent::VK_LEFT
      @cell_settings.adjust_cell_offset :left, +1 if event.key_code == KeyEvent::VK_RIGHT
    end

    def process_scroll_event(event)
      puts event
    end

    def process_wheel_event(event)
      plus_or_minus_one = event.wheel_rotation
      @view_settings.adjust_zoom plus_or_minus_one
    end

    def add_settings_changed_listener(listener)
      @listeners << listener
    end

    def on_settings_changed(id = SETTINGS_ID_UNKNOWN, value = nil)
      puts "setting #{id} to #{value}"
      send "#{id}=".to_sym, value if id != SETTINGS_ID_UNKNOWN
      update_char_grid_configuration
      broadcast id, value
    end

    private

    def update_char_grid_configuration
      @char_grid_configuration.cell_size = @cell_size
      @char_grid_configuration.cell_offset = @cell_offset
    end

    def broadcast(settings_id, settings_value)
      @listeners.each do |listener|
        listener.on_settings_changed settings_id, settings_value
      end
    end

    public

    def background_color
      Color::BLACK
    end

    def raster_color
      Color::DARK_GRAY
    end

    def font_color
      Color::WHITE
    end

    attr_accessor :zoom, :show_raster, :show_offset, :cell_size, :cell_offset

    def selected_font_name
      @font_settings.selected_font_name
    end

    def selected_font_size
      @font_settings.selected_font_size
    end

    def char_grid_configuration
      @char_grid_configuration
    end

  end

end
