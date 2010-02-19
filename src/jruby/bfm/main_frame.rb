module BFM

  import javax.swing.JFrame
  import javax.swing.WindowConstants

  class MainFrame < JFrame

    def initialize(ui_builder)
      super("BitmapFontMaker - An IntensiCode Tool")
      set_default_close_operation(WindowConstants.EXIT_ON_CLOSE)
      set_jmenu_bar(ui_builder.create_menu_bar)
      get_content_pane.add(ui_builder.create_content)
    end

    def center_and_resize_to(width_in_percent, height_in_percent)
      device = graphics_configuration.device
      mode = device.display_mode
      display_width = mode.width
      display_height = mode.height
      width = width_in_percent * display_width / 100
      height = height_in_percent * display_height / 100
      x = (display_width - width) / 2
      y = (display_height - height) / 2
      set_bounds(x, y, width, height)
    end

  end

end
