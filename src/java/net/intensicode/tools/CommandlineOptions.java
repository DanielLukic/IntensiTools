package net.intensicode.tools;

import java.util.ArrayList;

public final class CommandlineOptions
    {
    public CommandlineOptions( final String[] aArguments )
        {
        myArguments = aArguments;
        }

    public final boolean hasOption( final String aOptionName )
        {
        boolean found = false;
        for ( int idx = 0; idx < myArguments.length; idx++ )
            {
            final String argument = myArguments[idx];
            if ( argument == null ) continue;
            if ( !argument.equals( aOptionName ) ) continue;
            myArguments[idx] = null;
            found = true;
            }
        return found;
        }

    public final int getInteger( final String aOptionName, final int aDefaultValue )
        {
        final String value = extractLastValueAndDeleteAllOthersFor( aOptionName );
        if ( value == null ) return aDefaultValue;
        return Integer.parseInt( value );
        }

    public final String getString( final String aOptionName, final String aDefaultValue )
        {
        final String value = extractLastValueAndDeleteAllOthersFor( aOptionName );
        if ( value == null ) return aDefaultValue;
        return value;
        }

    public final String[] getList( final String aOptionName, final String[] aDefaultValue )
        {
        final ArrayList<String> result = new ArrayList<String>();
        while ( true )
            {
            final String value = extractFirstValueFor( aOptionName );
            if ( value == null ) break;
            result.add( value );
            }
        if ( result.size() == 0 ) return aDefaultValue;
        return result.toArray( new String[result.size()] );
        }

    public final String[] getRemainingArguments()
        {
        final ArrayList<String> remaining = new ArrayList<String>();
        for ( int idx = 0; idx < myArguments.length; idx++ )
            {
            final String argument = myArguments[idx];
            if ( argument == null ) continue;
            remaining.add( argument );
            }
        return remaining.toArray( new String[remaining.size()] );
        }

    // Implementation

    private String extractLastValueAndDeleteAllOthersFor( final String aOptionName )
        {
        String found = null;
        while ( true )
            {
            final String value = extractFirstValueFor( aOptionName );
            if ( value == null ) break;
            found = value;
            }
        return found;
        }

    private String extractFirstValueFor( final String aOptionName )
        {
        for ( int idx = 0; idx < myArguments.length; idx++ )
            {
            final String argument = myArguments[idx];
            if ( argument == null ) continue;

            if ( argument.equals( aOptionName ) ) // Check for "<name> <value>"
                {
                if ( idx < myArguments.length - 1 )
                    {
                    final String value = myArguments[idx + 1];
                    myArguments[idx] = myArguments[idx + 1] = null;
                    return value;
                    }
                }
            else
            if ( argument.startsWith( aOptionName ) ) // Check for "<name>=<value>"
                {
                final int assignment = argument.indexOf( '=' );
                if ( assignment != aOptionName.length() ) continue;
                final String value = argument.substring( assignment + 1 );
                myArguments[idx] = null;
                return value;
                }
            }
        return null;
        }

    private final String[] myArguments;
    }
