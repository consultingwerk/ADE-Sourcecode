/************************************************
Copyright (c) 2013-2019 by Progress Software Corporation. All rights reserved.
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
                
                Input-Output-By-Reference = Input-Output, ByReference
                InputOutputByReference    = Input-Output-By-Reference
                
                // complex data structures (PDS and TT)
                // these are here in addition to the OpenEdge.Core.DataTypeEnum since they are used to 
                // define parameters (DEFINE PARAMETER BUFFER localTable FOR Table, or 
                // DEFINE INPUT PARAMETER DATASET-HANDLE hdHdl)
                Table
                Table-Handle
                TableHandle  = Table-Handle
                
                Dataset
                Dataset-Handle
                DatasetHandle  = Dataset-Handle
                
                Buffer
                
                .
end enum.