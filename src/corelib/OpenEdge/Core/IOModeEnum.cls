/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : IOModeEnum
    Purpose     : IO Mode enumeration (for parameters). 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:22:58 EDT 2009
    Notes       : * This version based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.IOModeEnum final serializable inherits EnumMember: 

    define public static property Default                   as IOModeEnum no-undo get. private set.                                 
    define public static property Input                     as IOModeEnum no-undo get. private set.
    define public static property Output                    as IOModeEnum no-undo get. private set.
    define public static property OutputAppend              as IOModeEnum no-undo get. private set.
    define public static property InputOutput               as IOModeEnum no-undo get. private set.
    define public static property TableHandle               as IOModeEnum no-undo get. private set.
    define public static property TableHandleByReference    as IOModeEnum no-undo get. private set.
    define public static property DatasetHandle             as IOModeEnum no-undo get. private set.
    define public static property DatasetHandleByReference  as IOModeEnum no-undo get. private set.
    define public static property Return                    as IOModeEnum no-undo get. private set.
    
    constructor static IOModeEnum():
        IOModeEnum:Input = new IOModeEnum('Input').
        IOModeEnum:Output = new IOModeEnum('Output').
        IOModeEnum:OutputAppend = new IOModeEnum('Output-Append').
        IOModeEnum:InputOutput = new IOModeEnum('Input-Output').
        IOModeEnum:TableHandle = new IOModeEnum('Table-Handle').
        IOModeEnum:TableHandleByReference = new IOModeEnum('Table-Handle-By-Reference').
        IOModeEnum:DatasetHandle = new IOModeEnum('Dataset-Handle').
        IOModeEnum:DatasetHandleByReference = new IOModeEnum('Dataset-Handle-By-Reference').
        IOModeEnum:Return = new IOModeEnum('Return').
        
        IOModeEnum:Default = IOModeEnum:Input.
    end constructor.

    constructor public IOModeEnum(input pcName as character):
        super (input pcName).
    end constructor.
    
end class.
