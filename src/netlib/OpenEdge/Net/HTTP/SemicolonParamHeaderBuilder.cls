/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SemicolonParamHeaderBuilder
    Purpose     : Builder for headers that have semil-colon-delimted parameters 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 07 13:37:33 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.DefaultHeaderBuilder.

class OpenEdge.Net.HTTP.SemicolonParamHeaderBuilder inherits DefaultHeaderBuilder: 

    /* Constructor
       
       @param character The name of the header to which this builder applies */
    constructor public SemicolonParamHeaderBuilder ( input pcHeaderName as character ):
        super (input pcHeaderName).
        
        SetOption('paramDelimiter':u, ';':u).
    end constructor.
end class.