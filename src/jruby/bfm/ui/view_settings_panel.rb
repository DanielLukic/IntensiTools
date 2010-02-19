module BFM

  module UI

    import 'net.miginfocom.swing.MigLayout'

    import java.awt.image.BufferedImage
    import java.util.HashMap
    import java.util.logging.Logger
    import javax.swing.ImageIcon
    import javax.swing.JComboBox
    import javax.swing.JLabel
    import javax.swing.JPanel
    import javax.swing.JSpinner
    import javax.swing.border.TitledBorder

    class ViewSettingsPanel < JPanel

      include java.awt.event.ActionListener
      include javax.swing.event.ChangeListener

      def initialize(controller)
        super()

        @controller = controller

        zoom_model = SpinnerNumberModel.new(INITIAL_ZOOM, 1, 16, 1)
        @zoom_spinner = JSpinner.new(zoom_model)
        @zoom_spinner.add_change_listener self
        @zoom_label = JLabel.new("Zoom")
        @zoom_label.setLabelFor @zoom_spinner

        raster_checkbox = javax.swing.JCheckBox.new
        raster_checkbox.add_action_listener self
        raster_label = JLabel.new("Raster")
        raster_label.setLabelFor raster_checkbox

        setLayout MigLayout.new
        setBorder TitledBorder.new("View Settings")
        add @zoom_label
        add @zoom_spinner, "wrap"
        add raster_label
        add raster_checkbox, "wrap"

        @controller.set_view_settings_provider self
      end

      # From ActionListener

      def actionPerformed(event)
        @show_raster = !@show_raster
        @controller.on_settings_changed
      end

      # From ChangeListener

      def stateChanged(event)
        @controller.on_settings_changed
      end

      # From ViewSettingsProvider

      def selected_zoom
        @zoom_spinner.value
      end

      def selected_show_raster
        @show_raster
      end

      INITIAL_ZOOM = 2

    end

  end

end
