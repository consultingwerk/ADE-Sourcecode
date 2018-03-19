/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Web.DataObject.DataObjectService.

class OpenEdge.Web.DataObject.ServiceRegistryEventArgs inherits EventArgs:
    /* (mandatory) The service affected */
    define public property Service as DataObjectService no-undo get. private set.
    
    /* (mandatory) The name of the service affected */
    define public property ServiceName as character no-undo
        get():
            return Service:Name.
        end get.
    
    /* The version of the service */
    define public property Version as character no-undo
        get():
            return Service:Version:ToString().
        end get.
    
    /* Constructor
       
       @param DataObjectService The service  */
    constructor public ServiceRegistryEventArgs(input pService as DataObjectService):
        Assert:NotNull(pService, 'Data Service').
        
        assign this-object:Service = pService.
    end method.
                    
    /* Constructor
       
       @param character The service name affected */
    constructor public ServiceRegistryEventArgs(input pcServiceName as character):
        this-object(pcServiceName, '':u).         
    end constructor.
    
    /* Constructor
       
       @param character The service name affected
       @param SemanticVersion The version of the service */
    constructor public ServiceRegistryEventArgs(input pServiceName as character,
                                                input pVersion as SemanticVersion):
        this-object(new DataObjectService(pServiceName, pVersion)).
    end constructor.

    /* Constructor
       
       @param character The service name affected
       @param character The version of the service */
    constructor public ServiceRegistryEventArgs(input pServiceName as character,
                                                input pVersion as character):
        this-object(pServiceName, SemanticVersion:Parse(pVersion)).
    end constructor.
    
end class.