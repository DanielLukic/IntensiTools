module BFM

  require 'bfm/ui/cell_settings_panel'
  require 'bfm/ui/font_settings_panel'
  require 'bfm/ui/render_panel'

  import javax.swing.JMenuBar;
  import javax.swing.JPanel;
  import java.awt.BorderLayout;

  class UiBuilder

    def initialize(controller, renderer)
      @controller = controller
      @renderer = renderer
    end

    def create_menu_bar
      JMenuBar.new
    end

    def create_content
      main_panel = JPanel.new(BorderLayout.new)
      main_panel.add(BorderLayout::NORTH, BFM::UI::FontSettingsPanel.new(@controller, @renderer))
      main_panel.add(BorderLayout::CENTER, BFM::UI::RenderPanel.new(@controller, @renderer))
      main_panel.add(BorderLayout::EAST, BFM::UI::CellSettingsPanel.new(@controller))
      main_panel
    end

  end

end
