package net.intensicode.tools;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

public final class CellResizer
    {
    public static void main( final String[] aArgs ) throws IOException
        {
        final int cellsPerRow = 16;
        final int cellsPerColumn = 8;

        final int toCellWidth = 16;
        final int toCellHeight = 16;

        final boolean centered = true;

        final String inputFileName = "res/android/DroidShock/320x480/p/textfont.png";
        final String outputFileName = makeOutputFileName( inputFileName );

        final File inputFile = new File( inputFileName );
        if ( !inputFile.exists() ) showError( "Input file does not exist: " + inputFile );

        final BufferedImage inputImage = ImageIO.read( inputFile );
        final int fromCellWidth = inputImage.getWidth() / cellsPerRow;
        final int fromCellHeight = inputImage.getHeight() / cellsPerColumn;
        if ( inputImage.getWidth() != fromCellWidth * cellsPerRow )
            {
            showError( "Bad input image width: " + inputImage.getWidth() );
            }
        if ( inputImage.getHeight() != fromCellHeight * cellsPerColumn )
            {
            showError( "Bad input image height: " + inputImage.getHeight() );
            }

        final int[] inputBuffer = new int[fromCellWidth * fromCellHeight];
        final int[] outputBuffer = new int[toCellWidth * toCellHeight];

        final int outputWidth = cellsPerRow * toCellWidth;
        final int outputHeight = cellsPerColumn * toCellHeight;
        final BufferedImage outputImage = new BufferedImage( outputWidth, outputHeight, BufferedImage.TYPE_INT_ARGB );
        for ( int idx = 0; idx < outputWidth * outputHeight; idx++ )
            {
            final int x = idx % outputWidth;
            final int y = idx / outputWidth;
            outputImage.setRGB( x, y, 0 );
            }

        for ( int y = 0; y < cellsPerColumn; y++ )
            {
            for ( int x = 0; x < cellsPerRow; x++ )
                {
                final int inputX = x * fromCellWidth;
                final int inputY = y * fromCellHeight;
                inputImage.getRGB( inputX, inputY, fromCellWidth, fromCellHeight, inputBuffer, 0, fromCellWidth );

                convert( inputBuffer, fromCellWidth, outputBuffer, toCellWidth, centered );

                final int outputX = x * toCellWidth;
                final int outputY = y * toCellHeight;
                outputImage.setRGB( outputX, outputY, toCellWidth, toCellHeight, outputBuffer, 0, toCellWidth );
                }
            }

        ImageIO.write( outputImage, "png", new File( outputFileName ) );
        }

    private static void convert( final int[] aInput, final int aFromWidth, final int[] aOutput, final int aToWidth, final boolean aCentered )
        {
        final int fromHeight = aInput.length / aFromWidth;
        final int toHeight = aOutput.length / aToWidth;
        final int alignX = aCentered ? ( aFromWidth - aToWidth ) / 2 : 0;
        final int alignY = aCentered ? ( fromHeight - toHeight ) / 2 : 0;

        for ( int y = 0; y < toHeight; y++ )
            {
            final int inputY = y + alignY;
            if ( inputY < 0 || inputY >= fromHeight ) continue;

            for ( int x = 0; x < aToWidth; x++ )
                {
                final int inputX = x + alignX;
                if ( inputX < 0 || inputX >= aFromWidth ) continue;

                aOutput[ x + y * aToWidth ] = aInput[ inputX + inputY * aFromWidth ];
                }
            }

        }

    public static void showError( final String aMessage )
        {
        System.out.println( "ERROR: " + aMessage );
        System.exit( 10 );
        }

    public static String makeOutputFileName( final String aInputFileName )
        {
        final StringBuilder builder = new StringBuilder();

        final int lastDotPos = aInputFileName.lastIndexOf( '.' );
        if ( lastDotPos != -1 )
            {
            final String name = aInputFileName.substring( 0, lastDotPos );
            final String extension = aInputFileName.substring( lastDotPos );
            builder.append( name );
            builder.append( "_new" );
            builder.append( extension );
            return builder.toString();
            }

        builder.append( aInputFileName );
        builder.append( "_new" );
        return builder.toString();
        }
    }
