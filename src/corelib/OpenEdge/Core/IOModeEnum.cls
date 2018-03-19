/************************************************
Copyright (c)  2013-2017 by Progress Software Corporation. All rights reserved.
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

enum OpenEdge.Core.IOModeEnum flags:
    
    define enum // directions
                Input
                Output
                Return
                
                // modifiers
                Append
                Bind
                
                By-Reference
                ByReference = By-Reference
                
                By-Value
                ByValue = By-Value
                
                Default = Input
                
                // supported combos
                Input-By-Reference = Input, ByReference
                InputByReference   = Input-By-Reference
                
                Input-Bind = Input, Bind
                InputBind  = Input-Bind
                
                Output-By-Reference = Output, ByReference
                OutputByReference  = Output-By-Reference
                
                Output-Append = Output, Append
                OutputAppend  = Output-Append
                
                Output-Bind = Output, Bind
                OutputBind  = Output-Bind
                
                Input-Output = Input, Output
                InputOutput  = Input-Output
                
                Input-Output-By-Reference = Input, Output, ByReference
                InputOutputByReference    = Input-Output-By-Reference
                
                //@deprecated(since="11.7.2").
                Dataset-Handle
                
                //@deprecated(since="11.7.2").
                DatasetHandle  = Dataset-Handle
                
                //@deprecated(since="11.7.2").
                Dataset-Handle-By-Reference = DatasetHandle, ByReference
                //@deprecated(since="11.7.2").
                DatasetHandleByReference    = Dataset-Handle-By-Reference
                
                //@deprecated(since="11.7.2").
                Dataset-Handle-By-Value = DatasetHandle, ByValue
                //@deprecated(since="11.7.2").
                DatasetHandleByValue    = Dataset-Handle-By-Value
                
                //@deprecated(since="11.7.2").
                Table-Handle
                //@deprecated(since="11.7.2").
                TableHandle  = Table-Handle
                
                //@deprecated(since="11.7.2").
                Table-Handle-By-Reference = TableHandle, ByReference
                //@deprecated(since="11.7.2").
                TableHandleByReference    = Table-Handle-By-Reference
                
                //@deprecated(since="11.7.2").
                Table-Handle-By-Value = TableHandle, ByValue
                //@deprecated(since="11.7.2").
                TableHandleByValue    = Table-Handle-By-Value
                .
end enum.