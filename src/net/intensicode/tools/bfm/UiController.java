package net.intensicode.tools.bfm;

import java.util.ArrayList;

public final class UiController
    {
    public final void addSettingsChangedListener( final SettingsChangedListener aListener )
        {
        myListeners.add( aListener );
        }

    public final void onFontNameChanged( final String aFontName )
        {
        broadcast( SettingsChangedListener.FONT_NAME, aFontName );
        }

    public final void onFontSizeChanged( final Integer aSize )
        {
        broadcast( SettingsChangedListener.FONT_SIZE, aSize );
        }

    public final void onCellSizeChanged( final Integer aSize )
        {
        broadcast( SettingsChangedListener.CELL_SIZE, aSize );
        }

    public final void onCellOffsetChanged( final Integer aOffset )
        {
        broadcast( SettingsChangedListener.CELL_OFFSET, aOffset );
        }

    private void broadcast( final Object aSettingsId, final Object aSettingsValue )
        {
        for ( final SettingsChangedListener listener : myListeners )
            {
            listener.onSettingsChanged( aSettingsId, aSettingsValue );
            }
        }

    public final void setFontSettingsProvider( final FontSettingsProvider aFontSettingsProvider )
        {
        myFontSettingsProvider = aFontSettingsProvider;
        }

    public final void setCellSettingsProvider( final CellSettingsProvider aCellSettingsProvider )
        {
        myCellSettingsProvider = aCellSettingsProvider;
        }

    public final String getSelectedFontName()
        {
        return myFontSettingsProvider.getSelectedFontName();
        }

    public final Integer getSelectedFontSize()
        {
        return myFontSettingsProvider.getSelectedFontSize();
        }

    public final Integer getSelectedCellSize()
        {
        return myCellSettingsProvider.getSelectedCellSize();
        }

    public final Integer getSelectedCellOffset()
        {
        return myCellSettingsProvider.getSelectedCellOffset();
        }

    public final Integer getSelectedCellsPerRow()
        {
        return DEFAULT_CELLS_PER_ROW;
        }

    public final Integer getSelectedCellsPerColumn()
        {
        return DEFAULT_CELLS_PER_COLUMN;
        }

    public final int getSelectedZoomFactor()
        {
        return DEFAULT_ZOOM_FACTOR;
        }

    public final boolean getSelectedShowRasterFlag()
        {
        return DEFAULT_SHOW_RASTER_FLAG;
        }


    private FontSettingsProvider myFontSettingsProvider;

    private CellSettingsProvider myCellSettingsProvider;

    private final ArrayList<SettingsChangedListener> myListeners = new ArrayList<SettingsChangedListener>();

    private static final int DEFAULT_CELLS_PER_ROW = 16;

    private static final int DEFAULT_CELLS_PER_COLUMN = 8;

    private static final int DEFAULT_ZOOM_FACTOR = 4;

    private static final boolean DEFAULT_SHOW_RASTER_FLAG = true;
    }
