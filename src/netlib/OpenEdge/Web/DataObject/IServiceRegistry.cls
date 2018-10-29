/* *************************************************************************************************************************
Copyright (c) 2017-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IServiceRegistry
    Purpose     : Interface for an Data Object Service Registry 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-08-29
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.SemanticVersion.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistryEventArgs.
using Progress.Json.ObjectModel.JsonObject.

interface OpenEdge.Web.DataObject.IServiceRegistry:
    /* Event published when a a service has been de-registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define public event ServiceDeregistered signature void (input poSender as Progress.Lang.Object,
                                                            input poEventArgs as ServiceRegistryEventArgs).
    
    /* Event published when a a service has been registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define public event ServiceRegistered signature void (input poSender as Progress.Lang.Object,
                                                          input poEventArgs as ServiceRegistryEventArgs).
    
    /* Register a service
       
       @param DataObjectService  A data service  */
    method public void RegisterService(input pService as DataObjectService).
    
    /* Register a service 
       
       @param character  (mandatory) The service name
       @param SemanticVersion  (mandatory) The service version
       @param ServiceOptions (optional) A set of options for the service
       @param JsonObject (optional) A catalog for the service. Not all services have catalogs 
       @return DataObjectService  The registered data service */
    method public DataObjectService RegisterService(input pServiceName  as character,
                                                    input pVersion as SemanticVersion,
                                                    input pOptions as ServiceOptions,
                                                    input pCatalog as JsonObject).
    
    /* Removes a service registration  - the specified version
       
       @param character The name of the service to remove from the registry
       @param SemanticVersion The service version to deregister */
    method public void DeregisterService(input pServiceName as character,
                                         input pVersion as SemanticVersion).
    
    /* Returns the latest version of a service 
       
       @param character The name of the service to remove from the registry
       @return DataObjectService  A data service  */
    method public DataObjectService GetService(input pServiceName as character).
    
    /* Returns a versioned service 
       
       @param character The name of the service to remove from the registry
       @param character The service version to retrieve
       @return DataObjectService  A data service  */
    method public DataObjectService GetService(input pServiceName as character,
                                               input pVersion as character).
    
    /* Returns a versioned service 
       
       @param character The name of the service to remove from the registry
       @param SemanticVersion The service version to retrieve
       @return DataObjectService  A data service  */
    method public DataObjectService GetService(input pServiceName as character,
                                               input pVersion as SemanticVersion).
    
    /* Returns details about the operation, for the latest version of the service
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pcServiceName as character,
                                               input pcServiceURI as character,
                                               input poMethod as MethodEnum ).
    
    /* Returns details about the operation
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pVersion as SemanticVersion,
                                               input pServiceURI as character,
                                               input pMethod as MethodEnum ).

    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.
       
       @param character The service name
       @param SemanticVersion The service version 
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pVersion as SemanticVersion,
                                               input pOperationName as character).

    /* Returns details about the operation, for latest version of a service by name. 
       If more than one operation exists with the same name, pick the first.
       
       @param character The service name
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pOperationName as character).
    
    /* Returns an array of operations for the service 
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations(input pServiceName as character,
                                                       input pVersion as SemanticVersion ).
    
    /* Returns a named schema for a latest version of a service.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pcServiceName as character,
                                   input pcSchemaName as character).
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param SemanticVersion The service version 
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pServiceName as character,
                                   input pVersion as SemanticVersion,
                                   input pSchemaName as character).
    
    /* Returns all of the schemas associated with the latest version of a service.
       
       @param character The service name
       @param SemanticVersion The service version 
       @return handle[] An array of service schemas */
    method public handle extent GetSchemas(input pServiceName as character,
                                           input pVersion as SemanticVersion).
    
    /* Returns a catalog for the latest version of a service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public JsonObject GetServiceCatalog(input pcServiceName as character).
    
    /* Returns the service options for the latest version of a named service 
       
       @param character The service name. 
       @return ServiceOptions  A JSDO object containing options. If no exist or none can be 
                           found, return an empty JSON object.
       @throws AssertionFailedError If the name is empty or null */
    method public ServiceOptions GetServiceOptions(input pcServiceName as character).
    
    /* Returns all registered services
       
       @return DataObjectService[] extent An array of registered services. indeterminate if none. */
    method public DataObjectService extent GetServices().
    
    /* Returns an array of versions for a named service.
       
       @param character The service name
       @return SemanticVersion[] An array of service versions. Will always have at least 1 extent
       @throws AppError If the service is not registered */
    method public SemanticVersion extent GetServiceVersions(input pServiceName as character).
    
    /* Indicates whether a mapped operation exists for the latest version of a service  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pcServiceName as character,
                                       input pcServiceURI as character,
                                       input poMethod as MethodEnum ).
    
    /* Indicates whether a mapped operation exists for a specific version of a service  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pServiceURI as character,
                                       input pMethod as MethodEnum ).
    
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pOperationName as character).
    
    /* Indicates whether a schema exists with a given name  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The schema name
       @return logical TRUE if the schema exists */
    method public logical HasSchema(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pSchemaName as character).
    
    /* Indicates whether a schema exists with a given name  
       
       @param character the service name
       @param character The schema name
       @return logical TRUE if the schema exists */
    method public logical HasSchema(input pServiceName as character,
                                    input pSchemaName as character).
    
    /* Indicates whether a mapped operation exists with a given name for the latest version of a service  
       
       @param character the service name
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pOperationName as character).
    
    /* Indicates whether a named service is available in the registry.
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method public logical HasService(input pcServiceName as character).
    
    /* Indicates whether a named, versioned service is available in the registry.  
       
       @param character The name of the mapped service
       @param SemanticVersion The service version
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character,
                                     input pVersion as SemanticVersion).
    
    /* Indicates whether a named, versioned service is available in the registry.  
       
       @param character The name of the mapped service
       @param character The service version
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character,
                                     input pVersion as character).
    
    /* Adds a new operation map for a service.
       
       @param character The service name
       @param SemanticVersion The service version
       @param MappedOperation The operation map for this Method/URI */
    method public void PutOperation(input pcServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input poMappedOperation as MappedOperation).
    
    /* Saves a schema for a given service
       
       @param character The service name
       @param SemanticVersion The service version
       @param character The schema name
       @param handle    An empty data structure (TT or PDS) */
    method public void PutSchema(input pServiceName as character,
                                 input pVersion as SemanticVersion,
                                 input pSchemaName as character,
                                 input pSchema as handle).
    
    /* Sets a catalog for a named service 
       
       @param character The service name. 
       @param SemanticVersion The service version
       @param JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void PutServiceCatalog(input pServiceName as character,
                                         input pVersion as SemanticVersion,
                                         input pCatalog as JsonObject).
    
    /* Sets the service options for a named service 
       
       @param character The service name.
       @param SemanticVersion The service version
       @param ServiceOptions  The service options 
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void PutServiceOptions(input pServiceName as character,
                                         input pVersion as SemanticVersion,
                                         input pOptions as ServiceOptions).
    
    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.  
       
       @param character the service name 
       @param SemanticVersion The service version
       @param character The relative URI    
       @param MethodEnum The HTTP method    */
    method public void RemoveOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pServiceURI as character,
                                       input pMethod as MethodEnum).
    
    /* Removes an operation schema from service
       No-op if none exists.  
        
       @param character the service name    
       @param SemanticVersion The service version
       @param character The schema name   */
    method public void RemoveSchema(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pSchemaName as character).
    
end interface.