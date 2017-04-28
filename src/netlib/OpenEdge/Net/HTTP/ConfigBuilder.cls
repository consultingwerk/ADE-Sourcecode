/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConfigBuilder
    Purpose     : helper class for configuration data used by builders 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 19 14:55:32 EDT 2015
    Notes       : * Wraps the OE.Core.Util version
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.Net.HTTP.ConfigBuilder inherits OpenEdge.Core.Util.ConfigBuilder 
            abstract : 
end class.