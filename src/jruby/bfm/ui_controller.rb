module BFM

  import java.util.ArrayList

  class UiController

    SETTINGS_ID_FONT_NAME = :FONT_NAME
    SETTINGS_ID_FONT_SIZE = :FONT_SIZE
    SETTINGS_ID_CELL_SIZE = :CELL_SIZE
    SETTINGS_ID_CELL_OFFSET = :CELL_OFFSET

    DEFAULT_CELLS_PER_ROW = 16
    DEFAULT_CELLS_PER_COLUMN = 8
    DEFAULT_ZOOM_FACTOR = 4
    DEFAULT_SHOW_RASTER_FLAG = true


    def initialize
      @listeners = Array.new
    end

    def add_settings_changed_listener(listener)
      @listeners << listener
    end

    def on_font_name_changed(font_name)
      broadcast SETTINGS_ID_FONT_NAME, font_name
    end

    def on_font_size_changed(size)
      broadcast SETTINGS_ID_FONT_SIZE, size
    end

    def on_cell_size_changed(size)
      broadcast SETTINGS_ID_CELL_SIZE, size
    end

    def on_cell_offset_changed(offset)
      broadcast SETTINGS_ID_CELL_OFFSET, offset
    end

    private

    def broadcast(settings_id, settings_value)
      @listeners.each do |listener|
        listener.on_settings_changed settings_id, settings_value
      end
    end

    public

    def set_font_settings_provider(provider)
      @font_settings = provider
    end

    def set_cell_settings_provider(provider)
      @cell_settings = provider
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
      DEFAULT_ZOOM_FACTOR
    end

    def selected_show_raster_flag
      DEFAULT_SHOW_RASTER_FLAG
    end

  end

end
