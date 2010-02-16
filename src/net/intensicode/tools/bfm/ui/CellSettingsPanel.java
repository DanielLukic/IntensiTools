package net.intensicode.tools.bfm.ui;

import net.intensicode.tools.bfm.*;
import net.miginfocom.swing.MigLayout;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.*;
import java.util.logging.Logger;

public final class CellSettingsPanel extends JPanel implements ChangeListener, CellSettingsProvider
    {
    public CellSettingsPanel( final UiController aController )
        {
        myController = aController;

        myCellSizeSpinner.addChangeListener( this );
        myCellSizeLabel.setLabelFor( myCellSizeSpinner );

        myCellOffsetSpinner.addChangeListener( this );
        myCellOffsetLabel.setLabelFor( myCellOffsetSpinner );

        setLayout( new MigLayout() );
        setBorder( new TitledBorder( "Cell Settings" ) );
        add( myCellSizeLabel );
        add( myCellSizeSpinner, "wrap" );
        add( myCellOffsetLabel );
        add( myCellOffsetSpinner, "wrap" );

        myController.setCellSettingsProvider( this );
        }

    // From ChangeListener

    public final void stateChanged( final ChangeEvent e )
        {
        if ( e.getSource() == myCellSizeSpinner ) notifyNewCellSize();
        else if ( e.getSource() == myCellOffsetSpinner ) notifyNewCellOffset();
        else throw new RuntimeException( e.toString() );
        }

    // From CellSettingsProvider

    public final Integer getSelectedCellSize()
        {
        return (Integer) myCellSizeSpinner.getValue();
        }

    public final Integer getSelectedCellOffset()
        {
        return (Integer) myCellOffsetSpinner.getValue();
        }

    // Implementation

    private void notifyNewCellSize()
        {
        myController.onCellSizeChanged( getSelectedCellSize() );
        }

    private void notifyNewCellOffset()
        {
        myController.onCellOffsetChanged( getSelectedCellOffset() );
        }


    private final UiController myController;

    private final SpinnerModel myCellSizeModel = new SpinnerNumberModel( 16, 4, 128, 1 );

    private final JSpinner myCellSizeSpinner = new JSpinner( myCellSizeModel );

    private final JLabel myCellSizeLabel = new JLabel( "Cell size" );

    private final SpinnerModel myCellOffsetModel = new SpinnerNumberModel( 0, -128, 128, 1 );

    private final JSpinner myCellOffsetSpinner = new JSpinner( myCellOffsetModel );

    private final JLabel myCellOffsetLabel = new JLabel( "Cell offset" );

    private static final Logger LOG = Logger.getAnonymousLogger();
    }
