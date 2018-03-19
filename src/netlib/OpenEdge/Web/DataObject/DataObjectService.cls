/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataObjectService
    Purpose     : A representation of a Data Service
    Author(s)   : pjudge
    Created     : 2017-08-31
    Notes       : * the service provides access to contained schemas and operations within,
                    as well as a means to update/save itself in a registry 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistryImpl.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.DataObjectService:
    /* The registry from which this service came and/or should be stored */
    define public property Registry as IServiceRegistry no-undo
        get():
            // Use a CCS Service Manager if extant, and let it control this object's lifecycle
            // Don't hold a reference
            if valid-object(Ccs.Common.Application:ServiceManager) then
                return cast(Ccs.Common.Application:ServiceManager
                                                  :getService(get-class(IServiceRegistry)),
                            IServiceRegistry).
            
            if not valid-object(this-object:Registry) then
                assign this-object:Registry = new ServiceRegistryImpl().
            
            return this-object:Registry.
        end get.
        set.
    
    // Use a variable since we need the value to be CASE-SENSITIVE
    define private variable mName as character case-sensitive no-undo.
    
    /* (mandatory) The name of the service */
    define public property Name as character no-undo
        get():
            return mName.
        end get.
        // effectively private-set
    
    /* (mandatory) The version of the service */
    define public property Version as SemanticVersion no-undo get. private set.
    
    /* (optional) Options for this service. */
    define public property Options as ServiceOptions no-undo get. set.
    
    /* (optional) A Data Service Catalog associated with the service */
    define public property Catalog as JsonObject no-undo get. set.
    
    /* Constructor
       
       @param character The service name 
       @param character The service version */
    constructor public DataObjectService(input pName as character,
                                         input pVersion as SemanticVersion):
        super().
        
        Assert:NotNullOrEmpty(pName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        assign this-object:mName   = pName
               this-object:Version = pVersion
               .
    end constructor.
    
    method override public character ToString():
        return substitute('&1 v&2':u, this-object:Name, string(this-object:Version)).
    end method.
    
    method override public logical Equals(input pCompare as Object):
        if super:Equals(pCompare) then
            return true.
        
        if type-of(pCompare, OpenEdge.Web.DataObject.DataObjectService) then
            return (     this-object:Name    eq cast(pCompare, OpenEdge.Web.DataObject.DataObjectService):Name
                     and this-object:Version:Equals(cast(pCompare, OpenEdge.Web.DataObject.DataObjectService):Version)).
        
        return false.
    end method.
    
    /* OPERATIONS */
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pOperationName as character).
        return this-object:Registry:HasOperation(this-object:Name, this-object:Version,
                                                 input pOperationName).
    end method.
    
    /* Indicates whether a mapped operation exists for this service
       
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceURI as character,
                                       input pMethod as MethodEnum):
        return this-object:Registry:HasOperation(this-object:Name, this-object:Version,
                                                 input pServiceURI,
                                                 input pMethod).
    end method.
    
    /* Returns an array or operations for the service 
       
       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations():
        return this-object:Registry:GetOperations(this-object:Name, this-object:Version).
    end method.
            
    /* Returns details about an operation in this service
       
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */    
    method public MappedOperation GetOperation(input pServiceURI as character,
                                               input pMethod as MethodEnum):
        return this-object:Registry:GetOperation(this-object:Name, this-object:Version,
                                                 input pServiceURI,
                                                 input pMethod).
    end method.
    
    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.
       
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pOperationName as character):
        return this-object:Registry:GetOperation(this-object:Name, this-object:Version,
                                                 input pOperationName).
    end method.
    
    /* Adds a new operation map to this service
       
       @param MappedOperation The operation map for this Method/URI */
    method public void SaveOperation(input poMappedOperation as MappedOperation).
        this-object:Registry:PutOperation(this-object:Name, this-object:Version, 
                                          poMappedOperation).
    end method.
    
    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.  
       
       @param character The relative URI
       @param MethodEnum The HTTP method */
    method public void RemoveOperation(input pServiceURI as character,
                                       input pMethod as MethodEnum).
        this-object:Registry:RemoveOperation(this-object:Name, this-object:Version,
                                             input pServiceURI,
                                             input pMethod).
    end method.
    
    /** Registers this service in the registry if it has not been registered */
    method public void SaveService():
        if not this-object:Registry:HasService(this-object:Name, this-object:Version:ToString()) then
            this-object:Registry:RegisterService(this-object).
    end method.
    
    /* Sets the service options for a named service 
       
       @param ServiceOptions  The service options 
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void SaveOptions():
        this-object:Registry:PutServiceOptions(this-object:Name, this-object:Version,
                                               this-object:Options).
    end method.
    
    /* Sets a catalog for a named service 
       
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void SaveCatalog():
        this-object:Registry:PutServiceCatalog(this-object:Name, this-object:Version,
                                               this-object:Catalog).
    end method.
    
end class.