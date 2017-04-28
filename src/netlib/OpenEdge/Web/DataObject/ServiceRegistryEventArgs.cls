/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistryEventArgs
    Purpose     : Event args for the DOH service registry
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-19
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EventArgs.
using OpenEdge.Core.Assert.

class OpenEdge.Web.DataObject.ServiceRegistryEventArgs inherits EventArgs:
    /* (mandatory) The name of the service affected */
    define public property ServiceName as character no-undo get. private set.
    
    constructor public ServiceRegistryEventArgs(input pcServiceName as character):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        assign this-object:ServiceName = pcServiceName.
    end constructor.
end class.