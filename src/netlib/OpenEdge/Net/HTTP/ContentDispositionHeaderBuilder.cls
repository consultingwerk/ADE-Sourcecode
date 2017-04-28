/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentDispositionHeaderBuilder
    Purpose     : Bulider to create Content-Disposition header objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.ContentDispositionHeader.
using OpenEdge.Net.HTTP.DefaultHeaderBuilder.
using OpenEdge.Net.HTTP.HttpHeader.

class OpenEdge.Net.HTTP.ContentDispositionHeaderBuilder inherits DefaultHeaderBuilder: 

    /* Constructor
       
       @param character The name of the header to which this builder applies */
    constructor public ContentDispositionHeaderBuilder ( input pcHeaderName as character ):
        super (input pcHeaderName).
        
        SetOption('paramDelimiter':u, ';':u).
        SetOption(get-class(HttpHeader):TypeName, get-class(ContentDispositionHeader)).
    end constructor.

end class.