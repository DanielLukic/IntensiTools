package net.intensicode.tools.bfm;

import javax.swing.*;
import java.awt.*;

public final class MainFrame extends JFrame
    {
    public MainFrame( final UiBuilder aUiBuilder )
        {
        super( "BitmapFontMaker - An IntensiCode Tool" );
        setDefaultCloseOperation( WindowConstants.EXIT_ON_CLOSE );
        setJMenuBar( aUiBuilder.createMenuBar() );
        getContentPane().add( aUiBuilder.createContent() );
        }

    public final void centerAndResizeTo( final int aWidthInPercent, final int aHeightInPercent )
        {
        final GraphicsDevice device = getGraphicsConfiguration().getDevice();
        final DisplayMode mode = device.getDisplayMode();
        final int width = aWidthInPercent * mode.getWidth() / 100;
        final int height = aHeightInPercent * mode.getHeight() / 100;
        final int x = ( mode.getWidth() - width ) / 2;
        final int y = ( mode.getHeight() - height ) / 2;
        setBounds( x, y, width, height );
        }
    }
