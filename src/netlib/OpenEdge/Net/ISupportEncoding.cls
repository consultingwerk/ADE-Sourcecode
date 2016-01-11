/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportEncoding
    Purpose     : INdicates whether a writer supports character encoding 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 06 13:30:13 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Net.ISupportEncoding:
      
    /* Content encoding (eg utf-8) used by the implementer */ 
    define public property Encoding as character no-undo get. set.
    
end interface.