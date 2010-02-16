package net.intensicode.tools.bfm;

public interface SettingsChangedListener
    {
    String FONT_NAME = "FONT_NAME";
    String FONT_SIZE = "FONT_SIZE";
    String CELL_SIZE = "CELL_SIZE";
    String CELL_OFFSET = "CELL_OFFSET";

    void onSettingsChanged( Object aSettingsId, Object aSettingsValue );
    }
