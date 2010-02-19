package net.intensicode.tools.bfm.ui;

import net.intensicode.tools.bfm.*;
import net.miginfocom.swing.MigLayout;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.logging.Logger;

public final class FontSettingsPanel extends JPanel implements ActionListener, ChangeListener, FontSettingsProvider
    {
    public FontSettingsPanel( final UiController aController, final FontRenderer aFontRenderer )
        {
        myController = aController;
        myFontRenderer = aFontRenderer;

        prepareAvailableFonts();

        myFontBox = new JComboBox( myFontsAsIcons );
        myFontBox.addActionListener( this );
        myFontLabel.setLabelFor( myFontBox );
        myFontSizeSpinner.addChangeListener( this );
        myFontSizeLabel.setLabelFor( myFontSizeSpinner );

        setLayout( new MigLayout() );
        setBorder( new TitledBorder( "Font Settings" ) );
        add( myFontLabel );
        add( myFontBox, "wrap" );
        add( myFontSizeLabel );
        add( myFontSizeSpinner, "wrap" );

        myController.setFontSettingsProvider( this );
        }

    // From ActionListener

    public final void actionPerformed( final ActionEvent e )
        {
        if ( e.getSource() != myFontBox ) throw new RuntimeException( e.toString() );
        myController.onFontNameChanged( getSelectedFontName() );
        }

    // From ChangeListener

    public final void stateChanged( final ChangeEvent e )
        {
        if ( e.getSource() != myFontSizeSpinner ) throw new RuntimeException( e.toString() );
        myController.onFontSizeChanged( getSelectedFontSize() );
        }

    // From FontSettingsProvider

    public final String getSelectedFontName()
        {
        final Object selectedFont = myFontBox.getSelectedItem();
        return myIconToNameMap.get( selectedFont );
        }

    public final Integer getSelectedFontSize()
        {
        return (Integer) myFontSizeSpinner.getValue();
        }

    // Implementation

    private void prepareAvailableFonts()
        {
        final String[] fontNames = myFontRenderer.availableFontNames();
        myFontsAsIcons = new ImageIcon[fontNames.length];
        myIconToNameMap = new HashMap<ImageIcon, String>();

        for ( int idx = 0; idx < fontNames.length; idx++ )
            {
            final String fontName = fontNames[ idx ];
            final BufferedImage fontImage = myFontRenderer.renderFontName( fontName, FONT_SIZE_FOR_FONT_BOX );
            final ImageIcon fontIcon = new ImageIcon( fontImage );
            myFontsAsIcons[ idx ] = fontIcon;
            myIconToNameMap.put( fontIcon, fontName );
            }
        }


    private ImageIcon[] myFontsAsIcons;

    private HashMap<ImageIcon, String> myIconToNameMap;

    private final UiController myController;

    private final FontRenderer myFontRenderer;

    private final JComboBox myFontBox;

    private final JLabel myFontLabel = new JLabel( "Font" );

    private final SpinnerModel myFontSizeModel = new SpinnerNumberModel( 12, 1, 128, 1 );

    private final JSpinner myFontSizeSpinner = new JSpinner( myFontSizeModel );

    private final JLabel myFontSizeLabel = new JLabel( "Size" );

    private static final int FONT_SIZE_FOR_FONT_BOX = 32;

    private static final Logger LOG = Logger.getAnonymousLogger();
    }
