/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentTypeHeaderBuilder
    Purpose     : Bulider to create ContentType header objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 21 15:52:26 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.DefaultHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.ContentTypeHeader.

class OpenEdge.Net.HTTP.ContentTypeHeaderBuilder inherits DefaultHeaderBuilder: 

    /* Constructor
       
       @param character The name of the header to which this builder applies */
    constructor public ContentTypeHeaderBuilder ( input pcHeaderName as character ):
        super (input pcHeaderName).
        
        SetOption('paramDelimiter':u, ';':u).
        SetOption(get-class(HttpHeader):TypeName, get-class(ContentTypeHeader)).
    end constructor.

end class.