require 'yaml'

require 'bfm/char_grid_configuration'

module BFM

  import java.awt.event.KeyEvent
  import java.util.ArrayList

  class UiController

    SETTINGS_ID_UNKNOWN = :UNKNOWN

    INITIAL_ZOOM = 2

    def initialize(renderer)
      @renderer = renderer

      @listeners = Array.new
      @zoom = INITIAL_ZOOM
      @show_raster = @show_offset = false
      @char_grid_configuration = BFM::CharGridConfiguration.new
      @cell_size = @char_grid_configuration.cell_size
      @cell_offset = @char_grid_configuration.cell_offset

      @current_folder = Dir.pwd
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

    def font_name
      @font_name || @font_settings.font_name
    end

    def font_name=(value)
      @font_name = value
    end

    def font_size
      @font_size || @font_settings.font_size
    end

    def font_size=(value)
      @font_size = value
    end

    def char_grid_configuration
      @char_grid_configuration
    end

    attr_accessor :current_folder, :file

    def file_opened?
      not file.nil?
    end

    def load_from_file(file_path)
      puts "load #{file_path}"
      load_bfm_file file_path
    end

    def save_to_file(file_path)
      puts "save #{file_path}"
      save_bfm_file file_path
      save_font_image file_path.sub('.bfm', '.png')
    end

    private

    def load_bfm_file(file_path)
      File.open(file_path, 'r') do |file|
        data = YAML.load file
        data.each do |key,value|
          on_settings_changed key, value
        end
      end
    end

    def save_bfm_file(file_path)
      File.open(file_path, 'w') do |file|
        data = Hash.new
        data[:zoom] = zoom
        data[:show_raster] = show_raster
        data[:show_offset] = show_offset
        data[:cell_size] = cell_size
        data[:cell_offset] = cell_offset
        data[:font_name] = font_name
        data[:font_size] = font_size
        YAML.dump data, file
      end
    end

    def save_font_image(file_path)
      config = @char_grid_configuration
      image = @renderer.create_image config.grid_full_width, config.grid_full_height
      graphics = image.create_graphics
      graphics.font = @renderer.make_font(font_name, font_size)
      graphics.color = font_color
      @renderer.draw_char_grid graphics, config
      javax.imageio.ImageIO.write(image, "png", java.io.File.new(file_path))
    end

  end

end
