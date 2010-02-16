package net.intensicode.tools.bfm;

import java.awt.*;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;

public final class FontRenderer
    {
    public FontRenderer()
        {
        final BufferedImage tempImage = new BufferedImage( 32, 32, BufferedImage.TYPE_INT_ARGB );
        myFontRenderContext = tempImage.createGraphics().getFontRenderContext();
        }

    public final String[] availableFontNames()
        {
        final GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
        return environment.getAvailableFontFamilyNames();
        }

    public final BufferedImage[] renderAvailableFonts( final int aFontSize )
        {
        final String[] fontNames = availableFontNames();
        final BufferedImage[] images = new BufferedImage[fontNames.length];
        for ( int idx = 0; idx < images.length; idx++ )
            {
            final String fontName = fontNames[ idx ];
            final BufferedImage image = renderFontName( fontName, aFontSize );
            images[ idx ] = image;
            }
        return images;
        }

    public BufferedImage renderFontName( final String aFontName, final int aFontSize )
        {
        final Font font = makeFont( aFontName, aFontSize );
        final Rectangle2D fontBounds = font.getStringBounds( aFontName, myFontRenderContext );
        final BufferedImage image = createImage( (int) fontBounds.getWidth(), (int) fontBounds.getHeight() );
        final Graphics2D graphics = image.createGraphics();
        graphics.setColor( Color.WHITE );
        graphics.fillRect( 0, 0, image.getWidth(), image.getHeight() );
        graphics.setColor( Color.BLACK );
        graphics.setFont( font );
        graphics.drawString( aFontName, 0, (int) -fontBounds.getY() );
        return image;
        }

    // Implementation

    private BufferedImage createImage( final int aImageWidth, final int aImageHeight )
        {
        return new BufferedImage( aImageWidth, aImageHeight, BufferedImage.TYPE_INT_ARGB );
        }

//    public final BufferedImage renderFont( final FontSpec aFontSpec )
//        {
//        final FontRenderContext renderContext = getFontRenderContext();
//        final Font font = makeFont( aFontSpec.name, aFontSpec.size );
//        final Rectangle2D.Double maxCharBounds = determineMaxCharBounds( font );
//        final int charsToRender = LAST_CHAR_CODE_PLUS_ONE - FIRST_CHAR_CODE;
//        final int rowsToRender = ( charsToRender + CHARS_PER_ROW - 1 ) / CHARS_PER_ROW;
//        final int imageWidth = (int) ( CHARS_PER_ROW * maxCharBounds.getWidth() );
//        final int imageHeight = (int) ( rowsToRender * maxCharBounds.getHeight() );
//        final BufferedImage image = createImage( imageWidth, imageHeight );
//        final Graphics2D graphics = image.createGraphics();
//        graphics.setColor( Color.BLACK );
//        graphics.setFont( font );
//
//        int xPos = 0;
//        int yPos = 0;
//        for ( int idx = FIRST_CHAR_CODE; idx < LAST_CHAR_CODE_PLUS_ONE; idx++ )
//            {
//            CHAR_BUFFER[0] = (char) idx;
//            final Rectangle2D bounds = font.getStringBounds( CHAR_BUFFER, 0, 1, renderContext );
//            graphics.drawChars( CHAR_BUFFER, 0, 1, xPos, (int) ( yPos - bounds.getY() ) );
//            xPos += maxCharBounds.width;
//            if ( xPos >= imageWidth )
//                {
//                xPos = 0;
//                yPos += maxCharBounds.height;
//                }
//            }
//
//        return image;
//        }

//    private Rectangle2D.Double determineMaxCharBounds( final Font aFont )
//        {
//        final char[] charContainer = new char[1];
//        final FontRenderContext renderContext = getFontRenderContext();
//
//        final Rectangle2D.Double bounds = new Rectangle2D.Double();
//        for ( int idx = FIRST_CHAR_CODE; idx < LAST_CHAR_CODE_PLUS_ONE; idx++ )
//            {
//            charContainer[ 0 ] = (char) idx;
//            final Rectangle2D charBounds = aFont.getStringBounds( charContainer, 0, 1, renderContext );
//            bounds.width = Math.max( bounds.width, charBounds.getWidth() );
//            bounds.height = Math.max( bounds.height, charBounds.getHeight() );
//            }
//        return bounds;
//        }
//
//    private Rectangle2D.Double determineImageBounds( final String[] aFontNames, final int aFontSize )
//        {
//        final FontRenderContext renderContext = getFontRenderContext();
//
//        final Rectangle2D.Double bounds = new Rectangle2D.Double();
//        for ( final String fontName : aFontNames )
//            {
//            final Font font = makeFont( fontName, aFontSize );
//            final Rectangle2D fontBounds = font.getStringBounds( fontName, renderContext );
//            bounds.width = Math.max( bounds.width, fontBounds.getWidth() );
//            bounds.height += fontBounds.getHeight();
//            }
//        return bounds;
//        }

    private Font makeFont( final String fontName, final int aFontSize )
        {
        return new Font( fontName, Font.PLAIN, aFontSize );
        }


    private final FontRenderContext myFontRenderContext;

    private static final int DEFAULT_FONT_SIZE = 32;

    private static final int FIRST_CHAR_CODE = 32;

    private static final int LAST_CHAR_CODE_PLUS_ONE = 128;

    private static final int CHARS_PER_ROW = 16;

    private static final char[] CHAR_BUFFER = new char[1];
    }
