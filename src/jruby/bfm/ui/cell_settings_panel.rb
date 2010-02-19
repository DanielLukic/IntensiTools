module BFM

  module UI

    import 'net.miginfocom.swing.MigLayout'

    import javax.swing.JPanel
    import javax.swing.JSpinner
    import javax.swing.SpinnerNumberModel
    import javax.swing.border.TitledBorder
    import javax.swing.event.ChangeListener
    import java.util.logging.Logger


    class CellSettingsPanel < JPanel # implements ChangeListener, CellSettingsProvider

      include javax.swing.event.ChangeListener

      def initialize(controller)
        super()

        @controller = controller

        cell_size_model = SpinnerNumberModel.new( 16, 4, 128, 1 )
        @cell_size_spinner = JSpinner.new( cell_size_model )
        @cell_size_label = JLabel.new( "Cell size" )
        cell_offset_model = SpinnerNumberModel.new( 0, -128, 128, 1 )
        @cell_offset_spinner = JSpinner.new( cell_offset_model )
        @cell_offset_label = JLabel.new( "Cell offset" )

        @cell_size_spinner.addChangeListener( self )
        @cell_size_label.setLabelFor( @cell_size_spinner )

        @cell_offset_spinner.addChangeListener( self )
        @cell_offset_label.setLabelFor( @cell_offset_spinner )

        set_layout( MigLayout.new )
        set_border( TitledBorder.new( "Cell Settings" ) )
        add( @cell_size_label )
        add( @cell_size_spinner, "wrap" )
        add( @cell_offset_label )
        add( @cell_offset_spinner, "wrap" )

        @controller.set_cell_settings_provider( self )
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

      # From CellSettingsProvider

      def selected_cell_size
        @cell_size_spinner.value
      end

      def selected_cell_offset
        @cell_offset_spinner.value
      end

      # Implementation

      private

      def notify_new_cell_size
        @controller.on_cell_size_changed( selected_cell_size )
      end

      def notify_new_cell_offset
        @controller.on_cell_offset_changed( selected_cell_offset )
      end

    end

  end

end
