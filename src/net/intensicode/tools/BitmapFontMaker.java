package net.intensicode.tools;

import net.intensicode.tools.bfm.*;

import java.io.IOException;

public final class BitmapFontMaker
    {
    public static void main( final String[] aArgs ) throws IOException
        {
        final UiController controller = new UiController();
        final FontRenderer fontRenderer = new FontRenderer();
        final UiBuilder uiBuilder = new UiBuilder( controller, fontRenderer );
        final MainFrame frame = new MainFrame( uiBuilder );
        frame.centerAndResizeTo( 80, 80 );
        frame.setVisible( true );
        }
    }
