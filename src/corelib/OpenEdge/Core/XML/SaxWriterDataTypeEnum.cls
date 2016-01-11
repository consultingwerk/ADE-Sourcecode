/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SaxWriterDataTypeEnum
    Purpose     : Enumeration of the types that the SAX-WRITER can write as values
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 23 09:02:49 EST 2010
    Notes       : * This program based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.XML.SaxWriterDataTypeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.XML.SaxWriterDataTypeEnum serializable inherits EnumMember:
    
    define static public property CData as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Characters as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Comment as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property EntityReference as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Fragment as SaxWriterDataTypeEnum  no-undo get. private set.
        
    constructor static SaxWriterDataTypeEnum():
        SaxWriterDataTypeEnum:CData = new SaxWriterDataTypeEnum(1).
        SaxWriterDataTypeEnum:Characters = new SaxWriterDataTypeEnum(2).
        SaxWriterDataTypeEnum:Comment = new SaxWriterDataTypeEnum(3).
        SaxWriterDataTypeEnum:EntityReference = new SaxWriterDataTypeEnum(4).
        SaxWriterDataTypeEnum:Fragment = new SaxWriterDataTypeEnum(5).
    end constructor.
    
    constructor public SaxWriterDataTypeEnum(input piValue as integer):
        super (input piValue).
    end constructor.
    
end class.
