package net.intensicode.tools;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.ArrayList;

public final class BitmapitizerMain
    {
    public static void main( final String[] aArgs ) throws IOException
        {
        final BitmapitizerMain main = new BitmapitizerMain( aArgs );
        if ( main.isFontListRequested() ) main.listAvailableFonts();
        if ( main.isRenderedListRequested() ) main.renderAvailableFonts();

        final String[] fontSpecs = main.givenFontSpecs();
        for ( final String fontSpec : fontSpecs )
            {
            System.out.println( "Rendering " + fontSpec );

            final FontSpec spec = new FontSpec( fontSpec );
            final BufferedImage renderedFont = main.renderFont( spec );

            ImageIO.write( renderedFont, "png", new File( spec.name + "_" + spec.size + ".png" ) );
            }
        }

    public final BufferedImage renderFont( final FontSpec aFontSpec )
        {
        final FontRenderContext renderContext = getFontRenderContext();
        final Font font = makeFont( aFontSpec.name, aFontSpec.size );
        final Rectangle2D.Double maxCharBounds = determineMaxCharBounds( font );
        final int charsToRender = LAST_CHAR_CODE_PLUS_ONE - FIRST_CHAR_CODE;
        final int rowsToRender = ( charsToRender + CHARS_PER_ROW - 1 ) / CHARS_PER_ROW;
        final int imageWidth = (int) ( CHARS_PER_ROW * maxCharBounds.getWidth() );
        final int imageHeight = (int) ( rowsToRender * maxCharBounds.getHeight() );
        final BufferedImage image = createImage( imageWidth, imageHeight );
        final Graphics2D graphics = image.createGraphics();
        graphics.setColor( Color.BLACK );
        graphics.setFont( font );

        int xPos = 0;
        int yPos = 0;
        for ( int idx = FIRST_CHAR_CODE; idx < LAST_CHAR_CODE_PLUS_ONE; idx++ )
            {
            CHAR_BUFFER[0] = (char) idx;
            final Rectangle2D bounds = font.getStringBounds( CHAR_BUFFER, 0, 1, renderContext );
            graphics.drawChars( CHAR_BUFFER, 0, 1, xPos, (int) ( yPos - bounds.getY() ) );
            xPos += maxCharBounds.width;
            if ( xPos >= imageWidth )
                {
                xPos = 0;
                yPos += maxCharBounds.height;
                }
            }

        return image;
        }

    private BufferedImage createImage( final int aImageWidth, final int aImageHeight )
        {
        final BufferedImage image = new BufferedImage( aImageWidth, aImageHeight, BufferedImage.TYPE_INT_ARGB );
        final Graphics2D graphics = image.createGraphics();
        graphics.setColor( Color.WHITE );
        graphics.fillRect( 0, 0, aImageWidth, aImageHeight );
        graphics.setColor( Color.BLACK );
        return image;
        }

    private Rectangle2D.Double determineMaxCharBounds( final Font aFont )
        {
        final char[] charContainer = new char[1];
        final FontRenderContext renderContext = getFontRenderContext();

        final Rectangle2D.Double bounds = new Rectangle2D.Double();
        for ( int idx = FIRST_CHAR_CODE; idx < LAST_CHAR_CODE_PLUS_ONE; idx++ )
            {
            charContainer[0] = (char) idx;
            final Rectangle2D charBounds = aFont.getStringBounds( charContainer, 0, 1, renderContext );
            bounds.width = Math.max( bounds.width, charBounds.getWidth() );
            bounds.height = Math.max( bounds.height, charBounds.getHeight() );
            }
        return bounds;
        }

    public static final class FontSpec
        {
        public String name;

        public int size;

        public FontSpec( final String aFontNameWithOptionalSize )
            {
            if ( aFontNameWithOptionalSize.contains( ":" ) )
                {
                setFontNameAndSize( aFontNameWithOptionalSize );
                }
            else
                {
                setFontNameAndDefaultSize( aFontNameWithOptionalSize );
                }
            }

        public final void setFontNameAndSize( final String aFontNameAndSize )
            {
            final int colonPos = aFontNameAndSize.indexOf( ':' );
            name = aFontNameAndSize.substring( 0, colonPos );
            size = Integer.parseInt( aFontNameAndSize.substring( colonPos + 1 ) );
            }

        public final void setFontNameAndDefaultSize( final String aFontNameOnly )
            {
            name = aFontNameOnly;
            size = DEFAULT_FONT_SIZE;
            }
        }

    public BitmapitizerMain( final String[] aArguments )
        {
        myArguments = aArguments;
        }

    public final String[] givenFontSpecs()
        {
        final ArrayList<String> fontSpecs = new ArrayList<String>();
        for ( final String argument : myArguments )
            {
            if ( argument.startsWith( "--" ) ) continue;
            fontSpecs.add( argument );
            }
        return fontSpecs.toArray( new String[fontSpecs.size()] );
        }

    public final void listAvailableFonts()
        {
        final String[] fontNames = availableFontNames();
        for ( final String familyName : fontNames )
            {
            System.out.println( familyName );
            }
        }

    public final void renderAvailableFonts()
        {
        final String[] fontNames = availableFontNames();
        final int fontSize = selectedFontSize();
        final Rectangle2D bounds = determineImageBounds( fontNames, fontSize );
        final int imageWidth = (int) bounds.getWidth();
        final int imageHeight = (int) bounds.getHeight();
        final BufferedImage image = createImage( imageWidth, imageHeight );
        final FontRenderContext renderContext = getFontRenderContext();
        final Graphics2D graphics = image.createGraphics();

        int yPos = 0;
        for ( final String fontName : fontNames )
            {
            final Font font = makeFont( fontName, fontSize );
            graphics.setFont( font );
            final Rectangle2D fontBounds = font.getStringBounds( fontName, renderContext );
            graphics.drawString( fontName, 0, (int) ( yPos - fontBounds.getY() ) );
            yPos += fontBounds.getHeight();
            }

        try
            {
            ImageIO.write( image, "png", new File( "fonts.png" ) );
            }
        catch ( final IOException e )
            {
            e.printStackTrace();
            }
        }

    private Rectangle2D.Double determineImageBounds( final String[] aFontNames, final int aFontSize )
        {
        final FontRenderContext renderContext = getFontRenderContext();

        final Rectangle2D.Double bounds = new Rectangle2D.Double();
        for ( final String fontName : aFontNames )
            {
            final Font font = makeFont( fontName, aFontSize );
            final Rectangle2D fontBounds = font.getStringBounds( fontName, renderContext );
            bounds.width = Math.max( bounds.width, fontBounds.getWidth() );
            bounds.height += fontBounds.getHeight();
            }
        return bounds;
        }

    private Font makeFont( final String fontName, final int aFontSize )
        {
        return new Font( fontName, Font.PLAIN, aFontSize );
        }

    private FontRenderContext getFontRenderContext()
        {
        final BufferedImage tempImage = new BufferedImage( 256, 256, BufferedImage.TYPE_INT_ARGB );
        return tempImage.getGraphics().getFontMetrics().getFontRenderContext();
        }

    public final String[] availableFontNames()
        {
        final GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
        return environment.getAvailableFontFamilyNames();
        }

    public final int selectedFontSize()
        {
        for ( final String argument : myArguments )
            {
            if ( argument.startsWith( "--size=" ) )
                {
                final String sizeString = argument.substring( argument.indexOf( '=' ) );
                return Integer.parseInt( sizeString );
                }
            }
        return DEFAULT_FONT_SIZE;
        }

    public final boolean isFontListRequested()
        {
        for ( final String argument : myArguments )
            {
            if ( argument.equals( "--list" ) ) return true;
            if ( argument.equals( "--list-fonts" ) ) return true;
            }
        return false;
        }

    public final boolean isRenderedListRequested()
        {
        for ( final String argument : myArguments )
            {
            if ( argument.equals( "--render-list" ) ) return true;
            if ( argument.equals( "--render-fonts" ) ) return true;
            }
        return false;
        }

    private final String[] myArguments;

    private static final int DEFAULT_FONT_SIZE = 32;

    private static final int FIRST_CHAR_CODE = 32;

    private static final int LAST_CHAR_CODE_PLUS_ONE = 128;

    private static final int CHARS_PER_ROW = 16;

    private static final char[] CHAR_BUFFER = new char[1];
    }
