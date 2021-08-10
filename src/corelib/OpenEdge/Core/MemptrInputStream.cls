/* *************************************************************************************************************************
Copyright (c) 2019-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrInputStream
    Description : An InputStream implementation that holds data in-memory. This is
                  legacy code that now acts as a wrapper to the Progress.IO.MemoryInputStream
                  and should not be used
    Author(s)   : pjudge
    Created     : 2019-03-27
    Notes       : * This should be replaced in 12.0.0+ with the Progress.IO.MemoryInputStream, for performance reasons
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.IO.MemoryInputStream.

class OpenEdge.Core.MemptrInputStream inherits MemoryInputStream:
    
    constructor public MemptrInputStream (input pStream as Progress.IO.MemoryOutputStream):
        super(pStream).
    end constructor.
     
    constructor public MemptrInputStream (input pData as memptr):
        super(pData).
    end constructor.

end class.