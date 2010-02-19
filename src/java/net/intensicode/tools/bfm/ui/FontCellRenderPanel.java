package net.intensicode.tools.bfm.ui;

import net.intensicode.tools.bfm.*;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.util.logging.Logger;

public class FontCellRenderPanel extends JPanel implements SettingsChangedListener
    {
    public FontCellRenderPanel( final UiController aController )
        {
        myController = aController;
        myController.addSettingsChangedListener( this );
        }

    // From SettingsChangedListener

    public final void onSettingsChanged( final Object aSettingsId, final Object aSettingsValue )
        {
        updateSettings();
        updateBufferIfNecessary();
        updateFontIfNecessary();
        clearBackground();
        if ( myShowRaster ) drawCellRaster();
        drawFontChars();
        repaint();
        setSize( myRenderWidth, myRenderHeight );
        setPreferredSize( new Dimension( myRenderWidth, myRenderHeight ) );
        }

    // From JComponent

    protected final void paintComponent( final Graphics g )
        {
        super.paintComponent( g );
        if ( myBuffer == null ) onSettingsChanged( null, null );
        g.drawImage( myBuffer, 0, 0, myRenderWidth, myRenderHeight, null );
        }

    // Implementation

    private void updateSettings()
        {
        myZoomFactor = myController.getSelectedZoomFactor();
        myShowRaster = myController.getSelectedShowRasterFlag();
        myCellSize = myController.getSelectedCellSize();
        myCellOffset = myController.getSelectedCellOffset();
        myCellsPerRow = myController.getSelectedCellsPerRow();
        myCellsPerColumn = myController.getSelectedCellsPerColumn();
        myCellRasterWidth = myCellSize * myCellsPerRow;
        myCellRasterHeight = myCellSize * myCellsPerColumn;
        myRenderWidth = myCellRasterWidth * myZoomFactor;
        myRenderHeight = myCellRasterHeight * myZoomFactor;
        }

    private void updateBufferIfNecessary()
        {
        if ( isNewBufferNecessary() )
            {
            myBuffer = new BufferedImage( myCellRasterWidth, myCellRasterHeight, BufferedImage.TYPE_INT_ARGB );
            myBufferGraphics = myBuffer.createGraphics();
            }
        }

    private boolean isNewBufferNecessary()
        {
        return myBuffer == null || myBuffer.getWidth() != myCellRasterWidth || myBuffer.getHeight() != myCellRasterHeight;
        }

    private void updateFontIfNecessary()
        {
        final String fontName = myController.getSelectedFontName();
        final Integer fontSize = myController.getSelectedFontSize();
        if ( isNewFontNecessary( fontName, fontSize ) ) myFont = new Font( fontName, Font.PLAIN, fontSize );
        if ( myBufferGraphics.getFont() != myFont ) myBufferGraphics.setFont( myFont );
        }

    private boolean isNewFontNecessary( final String aFontName, final Integer aFontSize )
        {
        return myFont == null || !myFont.getName().equals( aFontName ) || myFont.getSize() != aFontSize;
        }

    private void clearBackground()
        {
        myBufferGraphics.setColor( Color.WHITE );
        myBufferGraphics.fillRect( 0, 0, getWidth(), getHeight() );
        }

    private void drawCellRaster()
        {
        myBufferGraphics.setColor( Color.LIGHT_GRAY );
        for ( int idx = 0; idx <= myCellsPerRow; idx++ )
            {
            myBufferGraphics.drawLine( idx * myCellSize, 0, idx * myCellSize, myCellRasterHeight );
            }
        for ( int idx = 0; idx <= myCellsPerColumn; idx++ )
            {
            myBufferGraphics.drawLine( 0, idx * myCellSize, myCellRasterWidth, idx * myCellSize );
            }
        }

    private void drawFontChars()
        {
        myBufferGraphics.setColor( Color.BLACK );
        for ( int column = 0; column < myCellsPerColumn; column++ )
            {
            final int yPos = column * myCellSize;
            for ( int row = 0; row < myCellsPerRow; row++ )
                {
                final int xPos = row * myCellSize;
                final int charIndex = 32 + row + column * myCellsPerRow;
                myCharBuffer[ 0 ] = (char) charIndex;
                final Rectangle2D bounds = myFont.getStringBounds( myCharBuffer, 0, 1, myBufferGraphics.getFontRenderContext() );
                myBufferGraphics.drawChars( myCharBuffer, 0, 1, (int) ( xPos - bounds.getX() ), myCellOffset + (int) ( yPos - bounds.getY() ) );
                }
            }
        }


    private int myZoomFactor;

    private boolean myShowRaster;

    private int myCellSize;

    private int myCellOffset;

    private int myCellsPerRow;

    private int myCellsPerColumn;

    private int myCellRasterWidth;

    private int myCellRasterHeight;

    private int myRenderWidth;

    private int myRenderHeight;

    private Font myFont;

    private BufferedImage myBuffer;

    private Graphics2D myBufferGraphics;

    private final UiController myController;

    private final char[] myCharBuffer = new char[1];

    private static final Logger LOG = Logger.getAnonymousLogger();
    }
