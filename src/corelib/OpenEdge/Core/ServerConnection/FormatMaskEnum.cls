/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : FormatMaskEnum
    Purpose     : Contains simple, substitutable masks, capable of being used with the basic
                  OpenEdge.Core.ServerConnection.ConnectionParameters class
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:25:46 EST 2013
    Notes       : More specialised masks, that will require specialised IConnectionParameters 
                  implementations. And example of this is the OpenEdge.Core.ServerConnection.WebServiceConnectionParameters
                  class.
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.ServerConnection.FormatMaskEnum:
    define enum       None 
                      DashSpace
                      DoubleDashEquals
                      DoubleDashSpace
                      NameEquals
                      Custom
                      
                      ABLConnect = DashSpace
                      Default = ABLConnect. 
end enum.
