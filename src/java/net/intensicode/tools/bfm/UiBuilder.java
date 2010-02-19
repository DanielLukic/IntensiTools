package net.intensicode.tools.bfm;

import net.intensicode.tools.bfm.ui.*;

import javax.swing.*;
import java.awt.*;

public final class UiBuilder
    {
    public UiBuilder( final UiController aController, final FontRenderer aFontRenderer )
        {
        myController = aController;
        myFontRenderer = aFontRenderer;
        }

    public final JMenuBar createMenuBar()
        {
        return new JMenuBar();
        }

    public final JPanel createContent()
        {
        final JPanel mainPanel = new JPanel( new BorderLayout() );
        mainPanel.add( BorderLayout.NORTH, new FontSettingsPanel( myController, myFontRenderer ) );
        mainPanel.add( BorderLayout.CENTER, new RenderPanel( myController ) );
        mainPanel.add( BorderLayout.EAST, new CellSettingsPanel( myController ) );
        return mainPanel;
        }

    private final UiController myController;

    private final FontRenderer myFontRenderer;
    }
