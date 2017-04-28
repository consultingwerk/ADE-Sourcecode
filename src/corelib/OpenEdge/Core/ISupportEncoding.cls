/************************************************
Copyright (c) 2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportEncoding
    Purpose     : Indicates whether a writer supports character encoding 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-01-27
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.ISupportEncoding:
    
    /* Content encoding (eg utf-8) used by the implementer */ 
    define public property Encoding as character no-undo get. set.
    
end interface.