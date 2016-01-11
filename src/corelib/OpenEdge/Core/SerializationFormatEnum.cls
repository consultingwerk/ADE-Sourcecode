/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SerializationFormatEnum
    Purpose     : Enumeration of serialization format types
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Aug 28 09:02:56 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Core.SerializationFormatEnum:
    define enum JSON
                QuotedJSON
                
                XML
                QuotedXML
                
                Binary
                .
end enum.