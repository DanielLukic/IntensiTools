require 'bfm/char_grid_configuration'

module BFM

  module UI

    import 'net.miginfocom.swing.MigLayout'

    import javax.swing.JPanel
    import javax.swing.JSpinner
    import javax.swing.SpinnerNumberModel
    import javax.swing.border.TitledBorder
    import javax.swing.event.ChangeListener
    import java.util.logging.Logger

    class CellSettingsPanel < JPanel

      include javax.swing.event.ChangeListener

      def initialize(controller)
        super()

        @controller = controller
        @cell_size = @controller.char_grid_configuration.cell_size
        @cell_offset = @controller.char_grid_configuration.cell_offset

        @offset_models = Hash.new

        cell_size_panel = JPanel.new(MigLayout.new)
        cell_size_panel.set_border(TitledBorder.new("Size"))
        add_size_controls cell_size_panel, :width
        add_size_controls cell_size_panel, :height

        cell_offset_panel = JPanel.new(MigLayout.new)
        cell_offset_panel.set_border(TitledBorder.new("Offset"))
        add_offset_controls cell_offset_panel, :top, 0, 1
        add_offset_controls cell_offset_panel, :left, 2, 0
        add_offset_controls cell_offset_panel, :right, 2, 3
        add_offset_controls cell_offset_panel, :bottom, 4, 1

        set_layout(MigLayout.new)
        set_border(TitledBorder.new("Cell Settings"))
        add cell_size_panel, "wrap"
        add cell_offset_panel, "wrap"

        @controller.set_cell_settings_provider self
      end

      def adjust_cell_offset(offset_id, delta)
        model = @offset_models[offset_id]
        new_value = model.value + delta
        return if new_value < model.minimum
        return if new_value > model.maximum
        model.value = new_value
      end

      def update_cell_size(size_id, spinner)
        @cell_size.send "#{size_id}=".to_sym, spinner.value
        notify_new_cell_size
      end

      def update_cell_offset(offset_id, spinner)
        @cell_offset.send "#{offset_id}=".to_sym, spinner.value
        notify_new_cell_offset
      end

      # From ChangeListener

      def stateChanged(event)
        if event.source == @cell_size_spinner
          notify_new_cell_size
        elsif event.source == @cell_offset_spinner
          notify_new_cell_offset
        else
          raise RuntimeException.new(event.to_s)
        end
      end

      private

      def notify_new_cell_size
        @controller.on_settings_changed :cell_size, @cell_size
      end

      def notify_new_cell_offset
        @controller.on_settings_changed :cell_offset, @cell_offset
      end

      def add_size_controls(panel, size_id)
        initial_size = @controller.char_grid_configuration.cell_size.send size_id
        cell_size_model = SpinnerNumberModel.new(initial_size, 4, 128, 1)
        spinner = JSpinner.new(cell_size_model)
        spinner.add_change_listener CellSizeUpdater.new(self, size_id)
        label = create_label(size_id.to_s, spinner)
        panel.add spinner
        panel.add label, "wrap"
      end

      def add_offset_controls(panel, offset_id, row, column)
        spinner = create_cell_offset_spinner(offset_id)
        label = create_label(offset_id.to_s, spinner)
        panel.add spinner, "cell #{column} #{row + 1} 1 1"
        panel.add label, "cell #{column} #{row} 1 1"
      end

      def create_cell_offset_spinner(offset_id)
        initial_offset = @controller.char_grid_configuration.cell_offset.send offset_id
        @offset_models[offset_id] = SpinnerNumberModel.new(initial_offset, -128, 128, 1)
        spinner = JSpinner.new(@offset_models[offset_id])
        spinner.add_change_listener CellOffsetUpdater.new(self, offset_id)
        spinner
      end

      def create_label(text, component)
        label = JLabel.new(text)
        label.set_label_for component
        label
      end


      INITIAL_CELL_SIZE = 16


      class CellSizeUpdater

        include javax.swing.event.ChangeListener

        def initialize(parent, size_id)
          @parent = parent
          @size_id = size_id
        end

        def stateChanged(event)
          @parent.update_cell_size @size_id, event.source
        end

      end


      class CellOffsetUpdater

        include javax.swing.event.ChangeListener

        def initialize(parent, offset_id)
          @parent = parent
          @offset_id = offset_id
        end

        def stateChanged(event)
          @parent.update_cell_offset @offset_id, event.source
        end

      end

    end

  end

end
