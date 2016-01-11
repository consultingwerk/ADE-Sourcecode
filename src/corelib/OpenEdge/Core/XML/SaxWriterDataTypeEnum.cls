/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
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

enum OpenEdge.Core.XML.SaxWriterDataTypeEnum :
    define enum       CData
                      Characters
                      Comment 
                      EntityReference 
                      Fragment. 
end enum.
