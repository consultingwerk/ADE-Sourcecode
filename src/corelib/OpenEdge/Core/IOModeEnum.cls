/************************************************
Copyright (c)  2013-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : IOModeEnum
    Purpose     : IO Mode enumeration (for parameters). 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:22:58 EDT 2009
    Notes       : * This version based on the AutoEdge|TheFactory version
                  * The hyphenated versions are added since the underlying
                    values were always those, and the name shortened. Built-in
                    enums don't allow you to set these independently
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.IOModeEnum:
    define enum Input                     
                Output                    
                
                Output-Append              
                OutputAppend = Output-Append
                
                Input-Output
                InputOutput = Input-Output                              
                
                Table-Handle               
                TableHandle = Table-Handle
                               
                Table-Handle-By-Reference    
                TableHandleByReference = Table-Handle-By-Reference
                    
                Dataset-Handle             
                DatasetHandle = Dataset-Handle
                
                Dataset-Handle-By-Reference
                DatasetHandleByReference = Dataset-Handle-By-Reference
                  
                Return
                
                Default = Input.                                 
end enum.
