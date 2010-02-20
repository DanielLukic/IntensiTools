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

        zoom_model = SpinnerNumberModel.new(@controller.zoom, 1, 16, 1)
        @zoom_spinner = JSpinner.new(zoom_model)
        @zoom_spinner.add_change_listener self
        zoom_label = JLabel.new("Zoom")
        zoom_label.setLabelFor @zoom_spinner

        @raster_checkbox = javax.swing.JCheckBox.new
        @raster_checkbox.add_action_listener self
        @raster_checkbox.selected = @controller.show_raster
        raster_label = JLabel.new("Show Raster")
        raster_label.setLabelFor @raster_checkbox

        @offset_checkbox = javax.swing.JCheckBox.new
        @offset_checkbox.add_action_listener self
        @offset_checkbox.selected = @controller.show_offset
        offset_label = JLabel.new("Show Offset")
        offset_label.setLabelFor @offset_checkbox

        setLayout MigLayout.new
        setBorder TitledBorder.new("View Settings")
        add zoom_label
        add @zoom_spinner, "wrap"
        add raster_label
        add @raster_checkbox, "wrap"
        add offset_label
        add @offset_checkbox, "wrap"

        @controller.set_view_settings_provider self
        @controller.add_settings_changed_listener self
      end

      def adjust_zoom(zoom_delta)
        model = @zoom_spinner.model
        new_zoom = model.value + zoom_delta
        return if new_zoom < model.minimum
        return if new_zoom > model.maximum
        model.value = new_zoom
      end

      def on_settings_changed(settings_id, settings_value)
        update_zoom settings_value if settings_id == :zoom
        update_show_raster settings_value if settings_id == :show_raster
        update_show_offset settings_value if settings_id == :show_offset
      end

      # From ActionListener

      def actionPerformed(event)
        toggle_show_raster if event.source == @raster_checkbox
        toggle_show_offset if event.source == @offset_checkbox
      end

      # From ChangeListener

      def stateChanged(event)
        @controller.on_settings_changed :zoom, @zoom_spinner.value
      end

      # Implementation

      private

      def update_zoom(new_or_unchanged_value)
        @zoom_spinner.value = new_or_unchanged_value if @zoom_spinner.value != new_or_unchanged_value
      end

      def update_show_raster(new_or_unchanged_value)
        @raster_checkbox.selected = new_or_unchanged_value if @raster_checkbox.selected != new_or_unchanged_value
      end

      def update_show_offset(new_or_unchanged_value)
        @offset_checkbox.selected = new_or_unchanged_value if @offset_checkbox.selected != new_or_unchanged_value
      end

      def toggle_show_raster
        show_raster = @raster_checkbox.selected
        @controller.on_settings_changed :show_raster, show_raster
      end

      def toggle_show_offset
        show_offset = @offset_checkbox.selected
        @controller.on_settings_changed :show_offset, show_offset
      end

    end

  end

end
