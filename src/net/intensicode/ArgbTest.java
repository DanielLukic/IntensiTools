package net.intensicode;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public final class ArgbTest
    {
    public static final void main( final String[] aArgs ) throws IOException
        {
        dumpCellData( 32, "res/Galaxina/Default/enemy1.png" );
        dumpCellData( 32, "res/Galaxina/Default/enemy2.png" );
        }

    private static final void dumpCellData( final int aCellSize, final String aFileName ) throws IOException
        {
        final File inputFile = new File( aFileName );

        final BufferedImage inputImage = ImageIO.read( inputFile );
        for ( int y = 0; y < aCellSize; y++ )
            {
            for ( int x = 0; x < aCellSize; x++ )
                {
                final int argb = inputImage.getRGB( x, y );
                final StringBuilder hex = new StringBuilder();
                hex.append( Integer.toHexString( argb ) );
                while ( hex.length() < 8 ) hex.insert( 0, '0' );
                hex.insert( 0, "0x" );
                hex.append( ' ' );
                System.out.print( hex.toString() );
                }
            System.out.println();
            }
        }
    }
