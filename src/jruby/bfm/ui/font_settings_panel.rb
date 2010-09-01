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
        @controller.add_settings_changed_listener self
      end

      def font_name
        selected_font = @font_box.selected_item
        @icon_to_name_map[selected_font]
      end

      def font_size
        @font_size_spinner.value
      end

      def on_settings_changed(settings_id, settings_value)
        update_font_name settings_value if settings_id == :font_name
        update_font_size settings_value if settings_id == :font_size
      end

      # From ActionListener

      def actionPerformed(event)
        @controller.on_settings_changed :font_name, font_name
      end

      # From ChangeListener

      def stateChanged(event)
        @controller.on_settings_changed :font_size, font_size
      end

      # Implementation

      private

      def update_font_name(new_or_unchanged_name)
        icon = @name_to_icon_map[new_or_unchanged_name]
        return unless icon
        @font_box.selected_item = icon if @font_box.selected_item != icon
      end

      def update_font_size(new_or_unchanged_size)
        @font_size_spinner.value = new_or_unchanged_size if @font_size_spinner.value != new_or_unchanged_size
      end

      def prepare_available_fonts
        @fonts_as_icons = Array.new
        @icon_to_name_map = Hash.new
        @name_to_icon_map = Hash.new
        @renderer.available_font_names.each do |name|
          begin
            image = @renderer.render_font_name(name, FONT_SIZE_FOR_FONT_BOX)
            icon = ImageIcon.new(image)
            @icon_to_name_map[icon] = name
            @name_to_icon_map[name] = icon
            @fonts_as_icons << icon
          rescue Exception => e
            puts "Skipping bad font #{name}"
          end
        end
      end

      FONT_SIZE_FOR_FONT_BOX = 32

    end

  end

end
