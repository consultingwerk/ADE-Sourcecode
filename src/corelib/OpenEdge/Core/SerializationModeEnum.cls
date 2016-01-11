/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SerializationModeEnum
    Purpose     : Enumeration of WRITE-*() and READ-*() method modes.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:17:26 EDT 2010
    Notes       : * Based on the ABL documentation 
                  * This program based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.SerializationModeEnum:
    define enum       File
                      Stream
                      Stream-Handle
                      StreamHandle = Stream-Handle 
                      Memptr
                      Handle
                      LongChar.
end enum.
