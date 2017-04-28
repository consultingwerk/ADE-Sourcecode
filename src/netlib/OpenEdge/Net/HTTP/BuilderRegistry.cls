/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BuilderRegistry
    Purpose     : General registry for name/Progress.Lang.Class pairs used
                  by the various HTTP-related builders. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 12 11:39:54 EST 2015
    Notes       : * this is technically a typed Map, but will be kept separate
                  * wrapper for the OE.Core.Util version, which moved
  ----------------------------------------------------------------------*/

class OpenEdge.Net.HTTP.BuilderRegistry inherits OpenEdge.Core.Util.BuilderRegistry:
    /** Default constructor */
    constructor public BuilderRegistry():
        super().
    end constructor.

    /** Constructor
    
        @param Progress.Lang.Class The type that the registered value must conform to
                                   (via IsA() ). */
    constructor public BuilderRegistry(input poValueType as Progress.Lang.Class):
        super(poValueType).
    end constructor.
    
end class.