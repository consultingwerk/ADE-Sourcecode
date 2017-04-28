/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IFileWriter
    Purpose     : Indicates whether we're writing to a file
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 17 11:21:34 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Logging.Writer.IFileWriter:
    // The output location

    define public property FileName as character no-undo get.
        
    // TRUE if we are appending to an existing file

    define public property Append as logical no-undo get. 
  
end interface.
