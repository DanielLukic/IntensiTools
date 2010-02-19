require 'bfm/ui/font_cell_render_panel'

module BFM

  module UI

    import java.awt.BorderLayout
    import javax.swing.JPanel
    import javax.swing.JScrollPane
    import javax.swing.border.TitledBorder

    class RenderPanel < JPanel

      def initialize(controller, renderer)
        super()
        set_layout BorderLayout.new
        set_border TitledBorder.new("Render Output")
        render_panel = FontCellRenderPanel.new(controller, renderer)
        scroll_pane = JScrollPane.new(render_panel)
        add scroll_pane, BorderLayout::CENTER
      end

    end

  end

end
