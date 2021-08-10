/* *************************************************************************************************************************
Copyright (c) 2019-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrOutputStream
    Description : An OutputStream implementation that holds data in-memory. This is
                  legacy code that now acts as a wrapper to the Progress.IO.MemoryOutputStream
                  and should not be used
    Author(s)   : pjudge
    Created     : 2019-02-20
    Notes       : * This should be replaced in 12.0.0+ with the Progress.IO.MemoryOutputStream, for performance reasons
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.IO.MemoryOutputStream.

class OpenEdge.Core.MemptrOutputStream inherits MemoryOutputStream:
    
    /* Default constructor */
    constructor public MemptrOutputStream():
        super().
    end constructor.
    
    constructor public MemptrOutputStream(input pSize as int64):
        super(pSize).
    end constructor.
    
end class.
