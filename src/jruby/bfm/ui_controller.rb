module BFM

  import java.util.ArrayList

  class UiController

    SETTINGS_ID_UNKNOWN = :UNKNOWN

    DEFAULT_CELLS_PER_ROW = 16
    DEFAULT_CELLS_PER_COLUMN = 8
    DEFAULT_ZOOM_FACTOR = 4
    DEFAULT_SHOW_RASTER_FLAG = true


    def initialize
      @listeners = Array.new
    end

    def process_key_event(event)
      puts event
    end

    def process_scroll_event(event)
      puts event
    end

    def add_settings_changed_listener(listener)
      @listeners << listener
    end

    def on_settings_changed(id = SETTINGS_ID_UNKNOWN, value = nil)
      broadcast id, value
    end

    private

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

    def set_font_settings_provider(provider)
      @font_settings = provider
    end

    def set_cell_settings_provider(provider)
      @cell_settings = provider
    end

    def set_view_settings_provider(provider)
      @view_settings = provider
    end

    def selected_font_name
      @font_settings.selected_font_name
    end

    def selected_font_size
      @font_settings.selected_font_size
    end

    def selected_cell_size
      @cell_settings.selected_cell_size
    end

    def selected_cell_offset
      @cell_settings.selected_cell_offset
    end

    def selected_cells_per_row
      DEFAULT_CELLS_PER_ROW
    end

    def selected_cells_per_column
      DEFAULT_CELLS_PER_COLUMN
    end

    def selected_zoom_factor
      @view_settings.selected_zoom
    end

    def selected_show_raster_flag
      @view_settings.selected_show_raster
    end

  end

end
