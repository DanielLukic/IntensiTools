package net.intensicode;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;

public final class FontSizer
    {
    public static final void main( final String[] aArgs ) throws IOException
        {
        final ArrayList<String> configs = new ArrayList<String>();
        configs.add( "BlockShock/176x208" );
        configs.add( "BlockShock/240x320" );
        configs.add( "BlockShock/LOW" );
        configs.add( "CuteBlocks/176x208" );
        configs.add( "CuteBlocks/240x320" );
        configs.add( "CuteBlocks/480x640" );
        configs.add( "WebShock/Default" );

        final String[] fonts = { "menufont", "scorefont", "textfont" };

        for ( final String config : configs )
            {
            for ( final String font : fonts )
                {
                final String fileName = MessageFormat.format( "res/{0}/{1}.png", config, font );
                process( fileName );
                }
            }
        }

    public static final void process( final String aInputFileName ) throws IOException
        {
        final int cellsPerRow = 16;
        final int cellsPerColumn = 8;

        //final int zeroSize = 3;
        //final int charOffset = 1;
        //final int cellWidth = 6;
        //final int cellHeight = 8;
        //final String inputFileName = "res/BlockShock/176x208/menufont.png";
        final String outputFileName = makeOutputFileName( aInputFileName );

        final File inputFile = new File( aInputFileName );
        if ( inputFile.exists() == false ) showError( "Input file does not exist: " + inputFile );

        final BufferedImage inputImage = ImageIO.read( inputFile );
        final int cellWidth = inputImage.getWidth() / cellsPerRow;
        if ( inputImage.getWidth() != (cellsPerRow * cellWidth) )
            {
            showError( "Bad input image width: " + inputImage.getWidth() );
            }
        final int cellHeight = inputImage.getHeight() / cellsPerColumn;
        if ( inputImage.getHeight() != (cellsPerColumn * cellHeight) )
            {
            showError( "Bad input image height: " + inputImage.getHeight() );
            }

        final int zeroSize = cellWidth * 2 / 3;
        final int charOffset = Math.max( 1, cellWidth / 8 );

        final int[] buffer = new int[cellWidth * cellHeight];

        //final int cellsPerRow = inputImage.getWidth() / cellWidth;
        //final int cellsPerColumn = inputImage.getHeight() / cellHeight;

        final DataOutputStream output = new DataOutputStream( new FileOutputStream( outputFileName ) );

        for ( int y = 0; y < cellsPerColumn; y++ )
            {
            for ( int x = 0; x < cellsPerRow; x++ )
                {
                final int inputX = x * cellWidth;
                final int inputY = y * cellHeight;
                inputImage.getRGB( inputX, inputY, cellWidth, cellHeight, buffer, 0, cellWidth );

                final int code = x + y * cellsPerRow;
                if ( code == 0 && zeroSize != -1 )
                    {
                    output.writeByte( zeroSize );
                    }
                else
                    {
                    final int width = findWidth( buffer, cellWidth, cellHeight ) + charOffset;
                    output.writeByte( width );
                    System.out.println( "Char code: " + code + " Width: " + width );
                    }
                }
            }

        output.close();
        }

    public static final int findWidth( final int[] aBuffer, final int aWidth, final int aHeight )
        {
        for ( int x = aWidth - 1; x >= 0; x-- )
            {
            boolean columnInUse = false;
            for ( int y = aHeight - 1; y >= 0; y-- )
                {
                final int dataPos = x + y * aWidth;
                final int alphaValue = aBuffer[ dataPos ] & 0xFF000000;
                if ( alphaValue != 0 ) columnInUse = true;
                }
            if ( columnInUse ) return Math.min( x, aWidth );
            }
        return 0;
        }

    public static final void showError( final String aMessage )
        {
        System.out.println( "ERROR: " + aMessage );
        System.exit( 10 );
        }

    public static final String makeOutputFileName( final String aaInputFileName )
        {
        final StringBuilder builder = new StringBuilder();

        final int lastDotPos = aaInputFileName.lastIndexOf( '.' );
        if ( lastDotPos != -1 )
            {
            final String name = aaInputFileName.substring( 0, lastDotPos );
            builder.append( name );
            builder.append( EXTENSION );
            return builder.toString();
            }

        builder.append( aaInputFileName );
        builder.append( EXTENSION );
        return builder.toString();
        }

    private static final String EXTENSION = ".dst";
    }