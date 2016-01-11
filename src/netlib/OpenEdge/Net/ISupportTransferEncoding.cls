/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportTransferEncoding
    Purpose     : Indicates whether this object supports character encoding
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jul 09 11:04:29 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Net.ISupportTransferEncoding:
    
    /* Transfer encoding (eg base63 or binary or 7bit or 8bit etc ) used by the implementer */ 
    define public property TransferEncoding as character no-undo get. set.  
    
end interface.