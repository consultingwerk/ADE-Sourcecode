/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportMultipartEntity
    Purpose     : Indicates whether this writer supports mutipart messages/entities
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 06 13:29:45 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Net.ISupportMultipartEntity:  

    /** The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo get. set.
  
end interface.