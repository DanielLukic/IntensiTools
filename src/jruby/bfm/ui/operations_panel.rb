module BFM

  module UI

    import 'net.miginfocom.swing.MigLayout'

    import javax.swing.JButton
    import javax.swing.JFileChooser
    import javax.swing.JPanel
    import javax.swing.border.TitledBorder

    class OperationsPanel < JPanel

      include java.awt.event.ActionListener

      def initialize(controller)
        super()

        @controller = controller

        @load = JButton.new("Load")
        @load.add_action_listener self
        @save = JButton.new("Save")
        @save.add_action_listener self
        @save_as = JButton.new("Save As")
        @save_as.add_action_listener self

        setLayout MigLayout.new
        setBorder TitledBorder.new("Operations")
        add @load, "wrap"
        add @save, "wrap"
        add @save_as, "wrap"
      end

      # From ActionListener

      def actionPerformed(event)
        trigger_load_dialog if event.source == @load
        trigger_save_or_save_dialog if event.source == @save
        trigger_save_dialog if event.source == @save_as
      end

      private

      def trigger_load_dialog
        show_dialog(:open) { |selected_file| trigger_load selected_file }
      end

      def trigger_save_or_save_dialog
        if @controller.file_open?
          @controller.save_to_file
        else
          trigger_save_dialog
        end
      end

      def trigger_save_dialog
        show_dialog(:save) { |selected_file| trigger_save selected_file }
      end

      def show_dialog(type_id, &block)
        chooser = make_chooser_dialog
        choosen_option = chooser.send("show_#{type_id}_dialog".to_sym, self)
        yield chooser.selected_file if choosen_option == JFileChooser::APPROVE_OPTION
      end

      def make_chooser_dialog
        chooser = JFileChooser.new(@controller.current_folder)
        filter = javax.swing.filechooser.FileNameExtensionFilter.new("BitmapFontMaker", ["bfm"].to_java(:String))
        chooser.file_filter = filter
        chooser
      end

      def trigger_load(file)
        proper_file_name_and_path = make_proper_file_name_and_path(file)
        @controller.load_from_file proper_file_name_and_path
      end

      def trigger_save(file)
        proper_file_name_and_path = make_proper_file_name_and_path(file)
        @controller.save_to_file proper_file_name_and_path
      end

      def make_proper_file_name_and_path(file)
        name = make_proper_name(file.name)
        File.join(file.parent, name)
      end

      def make_proper_name(file_name_possibly_lacking_suffix)
        return file_name_possibly_lacking_suffix if file_name_possibly_lacking_suffix.downcase =~ /\.bfm$/
        file_name_possibly_lacking_suffix + '.bfm'
      end

    end

  end

end
