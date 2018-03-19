/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceDiscoveryEventArgs
    Purpose     : Event args for the service lookup event in the DOH
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-08-31
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.HandleRequestEventArgs.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.IWebRequest.

class OpenEdge.Web.DataObject.ServiceDiscoveryEventArgs inherits HandleRequestEventArgs:
    // Use a variable since we need the value to be CASE-SENSITIVE
    define private variable mName as character case-sensitive no-undo.
    
    // Use a variable since we need the value to be CASE-SENSITIVE
    define private variable mUri as character case-sensitive no-undo.
    
    /* (optional) The requested name of the service */
    define public property Name as character no-undo
        get():
            return mName.
        end get.
        set(input pName as character):
            Assert:NotNullOrEmpty(pName).
            
            assign mName = pName.
        end set.
    
    /* (optional) The request version of the service */
    define public property Version as character no-undo get. set.
    
    /* (optional) The registry from which this service came and/or should be stored */
    define public property Registry as IServiceRegistry no-undo get. set.
    
    /* (optional) The relative URI for this operation. */
    define public property ServiceURI as character no-undo
        get():
            return mUri.
        end get.
        set(input pUri as character):
            Assert:NotNull(pUri, 'Service URI').
            assign mUri = pUri.
        end set.
    
    /* The actual service to use ('real' service name and version) */
    define public property Service as DataObjectService no-undo get. set.
    
    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception  */
    constructor public ServiceDiscoveryEventArgs (input pRequest as IWebRequest):
        super(input pRequest).
    end constructor.

    /* Constructor.
       
       @param IWebRequest The request that resulting in the exception  */
    constructor public ServiceDiscoveryEventArgs (input pRequest as IWebRequest,
                                                  input pRegistry as IServiceRegistry):
        super(input pRequest).
        
        Assert:NotNull(pRegistry, 'Service registry').
        assign this-object:Registry = pRegistry.
    end constructor.
    
end class.