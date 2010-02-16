package net.intensicode.tools.bfm.ui;

import net.intensicode.tools.bfm.UiController;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;

public final class RenderPanel extends JPanel
    {
    public RenderPanel( final UiController aController )
        {
        setLayout( new BorderLayout() );
        setBorder( new TitledBorder( "Render Output" ) );
        final FontCellRenderPanel renderPanel = new FontCellRenderPanel( aController );
        final JScrollPane scrollPane = new JScrollPane( renderPanel );
        add( scrollPane, BorderLayout.CENTER );
        }
    }
