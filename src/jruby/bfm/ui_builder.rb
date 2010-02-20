module BFM

  import 'net.miginfocom.swing.MigLayout'
  
  require 'bfm/ui/cell_settings_panel'
  require 'bfm/ui/font_settings_panel'
  require 'bfm/ui/operations_panel'
  require 'bfm/ui/render_panel'
  require 'bfm/ui/view_settings_panel'

  import java.awt.BorderLayout;
  import javax.swing.JMenuBar;
  import javax.swing.JPanel;

  class UiBuilder

    def initialize(controller, renderer)
      @controller = controller
      @renderer = renderer
    end

    def create_menu_bar
      JMenuBar.new
    end

    def create_content
      top_panel = JPanel.new(MigLayout.new)
      top_panel.add BFM::UI::OperationsPanel.new(@controller)
      top_panel.add BFM::UI::ViewSettingsPanel.new(@controller)
      top_panel.add BFM::UI::FontSettingsPanel.new(@controller, @renderer)

      main_panel = JPanel.new(BorderLayout.new)
      main_panel.add BorderLayout::NORTH, top_panel
      main_panel.add BorderLayout::CENTER, BFM::UI::RenderPanel.new(@controller, @renderer)
      main_panel.add BorderLayout::EAST, BFM::UI::CellSettingsPanel.new(@controller)
      main_panel
    end

  end

end
