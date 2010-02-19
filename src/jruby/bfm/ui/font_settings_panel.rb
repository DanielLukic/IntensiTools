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

    class FontSettingsPanel < JPanel

      include java.awt.event.ActionListener
      include javax.swing.event.ChangeListener

      def initialize(controller, renderer)
        super()

        @controller = controller
        @renderer = renderer

        prepare_available_fonts

        @font_label = JLabel.new("Font")
        @font_size_model = SpinnerNumberModel.new(12, 1, 128, 1)
        @font_size_spinner = JSpinner.new(@font_size_model)
        @font_size_label = JLabel.new("Size")

        @font_box = JComboBox.new(@fonts_as_icons.to_java)
        @font_box.add_action_listener self
        @font_label.setLabelFor @font_box
        @font_size_spinner.add_change_listener self
        @font_size_label.setLabelFor @font_size_spinner

        setLayout MigLayout.new
        setBorder TitledBorder.new("Font Settings")
        add @font_label
        add @font_box, "wrap"
        add @font_size_label
        add @font_size_spinner, "wrap"

        @controller.set_font_settings_provider self
      end

      # From ActionListener

      def actionPerformed(event)
        @controller.on_font_name_changed(selected_font_name)
      end

      # From ChangeListener

      def stateChanged(event)
        @controller.on_font_size_changed(selected_font_size)
      end

      # From FontSettingsProvider

      def selected_font_name
        selected_font = @font_box.getSelectedItem
        @icon_to_name_map[selected_font]
      end

      def selected_font_size
        @font_size_spinner.getValue
      end

      # Implementation

      private

      def prepare_available_fonts
        @fonts_as_icons = Array.new
        @icon_to_name_map = Hash.new
        @renderer.available_font_names.each do |name|
          image = @renderer.render_font_name(name, FONT_SIZE_FOR_FONT_BOX)
          icon = ImageIcon.new(image)
          @icon_to_name_map[icon] = name
          @fonts_as_icons << icon
        end
      end

      FONT_SIZE_FOR_FONT_BOX = 32

    end

  end

end
