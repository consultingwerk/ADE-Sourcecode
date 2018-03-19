/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistryImpl
    Purpose     : Contains a registry for mapped services 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.ServiceRegistryEventArgs.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.ServiceRegistryImpl implements ISupportLogging, IServiceRegistry:
    
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
    
    // The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986)
    define private static temp-table Service no-undo
        //KEYS
        field Id as character                // guid
        
        field ServiceName as character case-sensitive
        field Major as integer
        field Minor as integer
        field Patch as integer
        field PreRelease as character
        //DATA
        field Service           as Progress.Lang.Object     // OpenEdge.Web.DataObject.DataObjectService
        
        // for finding
        index idx1 as primary unique ServiceName Major Minor Patch PreRelease
        // parent key for other tables
        index idx2 as unique Id
        .
    
    // The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986)
    define private static temp-table Operation no-undo
        //KEYS
        field Service           as character                // guid
        field URI               as character case-sensitive // / or another path
        field Method            as character                // HTTP method (GET|PUT|POST|DELETE|...) 
        //DATA
        field Name            as character              //an optional name
        field MappedOperation as Progress.Lang.Object   // OpenEdge.Web.DataObject.MappedOperation  
        index idx1 as primary unique Service URI Method
        index idx2 Service Name
        .
    
    // The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986)
    define private static temp-table DataSchema no-undo
        //KEYS
        field Service           as character                // guid
        //DATA
        field SchemaName    as character
        field DataStructure as handle
        index idx1 as primary unique Service SchemaName
        .
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /* Default constructor */
    constructor public ServiceRegistryImpl():
        assign // Note that it's NOT the ServiceRegistryImpl type
               this-object:Logger = LoggerBuilder:GetLogger(get-class(ServiceRegistry)).
    end constructor.
    
    /* Destructor */
    destructor ServiceRegistryImpl():
        define buffer lbService for Service.
        
        // Publish the deregistration
        for each lbService:
            DeregisterService(cast(lbService.Service, DataObjectService):Name, cast(lbService.Service, DataObjectService):Version).
        end.
    end destructor.
    
    /* Adds a service
       
       @param DataObjectService  A data service 'header' */
    method public void RegisterService(input pService as DataObjectService):
        define buffer lbService for Service.
        
        Assert:NotNull(pService, 'Service').
        
        FindServiceRecord(pService:Name, pService:Version, buffer lbService).
        if not available lbService then
        do:
            create lbService.
            assign lbService.Id          = guid
                   lbService.ServiceName = pService:Name
                   lbService.Major       = pService:Version:Major
                   lbService.Minor       = pService:Version:Minor
                   lbService.Patch       = pService:Version:Patch
                   lbService.PreRelease  = pService:Version:PreRelease
                   lbService.Service     = pService
                   .
            OnServiceRegistered(new ServiceRegistryEventArgs(pService)).
        end.
    end method.
    
    /* Register a service 
       
       @param character (mandatory) The service name
       @param SemanticVersion  (mandatory) The service semantic version
       @param ServiceOptions (optional) A set of options for the service
       @param JsonObject (optional) A catalog for the service. Not all services have catalogs */
    method public void RegisterService(input pServiceName  as character,
                                       input pVersion as SemanticVersion,
                                       input pOptions as ServiceOptions,
                                       input pCatalog as JsonObject):
        define variable svc as DataObjectService no-undo.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        assign svc = new DataObjectService(pServiceName, pVersion)
               /* these can both be can be unknown */
               svc:Options = pOptions
               svc:Catalog = pCatalog
               .
        RegisterService(svc).
    end method.
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character):
        define buffer lbService for Service.
        
        find first lbService where
                   lbService.ServiceName eq pServiceName
                   no-error. 
        if available lbService then
            return true.
        
        find first lbService where
                   lbService.ServiceName eq trim(pServiceName, '/':u)
                   no-error. 
        
        return (available lbService).
    end method.
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @param character The service version
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character,
                                     input pVersion as character):        
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        FindServiceRecord(pServiceName, SemanticVersion:Parse(pVersion), buffer lbService).
        
        return (available lbService).
    end method.
    
    /* Returns a the latest version of a service 
       
       @param character The name of the service to remove from the registry
       @return DataObjectService  A data service 'header' */
    method public DataObjectService GetService(input pServiceName as character):
        define buffer lbService for Service.

        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        FindServiceLatest(pServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pServiceName), 0).
        
        return cast(lbService.Service, DataObjectService).
    end method.
    
    /* Returns a service object
       
       @param character The name of the service to remove from the registry
       @param character The service version to deregister 
       @return DataObjectService  A data service 'header' */
    method public DataObjectService GetService(input pServiceName as character,
                                               input pVersion as character).
        define buffer lbService for Service.

        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        // return latest
        if pVersion eq '':u then
            return GetService(pServiceName).
        
        FindServiceRecord(pServiceName, SemanticVersion:Parse(pVersion), buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        return cast(lbService.Service, DataObjectService).
    end method.
    
    /* Returns all registered services
       
       @return DataObjectService[] extent An array of registered services. indeterminate if none. */
    method public DataObjectService extent GetServices().
        define variable services as DataObjectService extent no-undo.
        
        define buffer lbService for Service.
        define query qryService for lbService.
        
        open query qryService preselect each lbService.
        
        assign extent(services) = query qryService:num-results
               no-error.
        
        get first qryService.
        do while available lbService:
            assign services[query qryService:current-result-row] = cast(lbService.Service, DataObjectService).
            get next qryService.
        end.
        
        return services.
        finally:
            close query qryService.
        end finally.
    end method.
    
    /* Returns an array of versions for this service.
       
       @param character The service name
       @return SemanticVersion[] An array of service versions. Will always have at least 1 extent
       @throws AppError If the service is not registered */
    method public SemanticVersion extent GetServiceVersions(input pServiceName as character):
        define variable svcVersions as SemanticVersion extent no-undo.
        
        define buffer lbService for Service.
        define query qryService for lbService.
        
        open query qryService 
                preselect each lbService where
                               lbService.ServiceName eq pServiceName
                               no-lock.
        if query qryService:num-results eq 0 then
            undo, throw new AppError(substitute('Unable to find service "&1"', pServiceName), 0).
        
        assign extent(svcVersions) = query qryService:num-results.
        
        get first qryService.
        do while available lbService:
            assign svcVersions[query qryService:current-result-row] = cast(lbService.Service, DataObjectService):Version.
            get next qryService.
        end.
        
        return svcVersions.
        finally:
            close query qryService.
        end finally.
    end method.
    
    /* Sets the service options for a named service 
       
       @param character The service name.
       @param SemanticVersion The service version
       @param ServiceOptions  The service options 
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void PutServiceOptions(input pServiceName as character,
                                         input pVersion as SemanticVersion,
                                         input pOptions as ServiceOptions):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pOptions, 'Service options').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        assign cast(lbService.Service, DataObjectService):Options = pOptions.
    end method.
    
    /* Returns the service options for a named service 
       
       @param character The service name. 
       @return ServiceOptions  The service options.
       @throws AssertionFailedError If the name is empty or null 
       @throws AppError If the service is not registered */
    method public ServiceOptions GetServiceOptions(input pcServiceName as character):
        define variable oOptions as ServiceOptions no-undo.

        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        FindServiceLatest(pcServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pcServiceName), 0).
        
        return cast(lbService.Service, DataObjectService):Options.
    end method.
    
    /* Sets a catalog for a named service 
       
       @param character The service name. 
       @param SemanticVersion The service version
       @param JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public void PutServiceCatalog(input pServiceName as character,
                                         input pVersion as SemanticVersion,
                                         input pCatalog as JsonObject):    
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pCatalog, 'Catalog').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        assign cast(lbService.Service, DataObjectService):Catalog = pCatalog.
    end method.
    
    /* Returns a catalog for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public JsonObject GetServiceCatalog(input pcServiceName as character):
        define variable oOptions as ServiceOptions no-undo.

        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        FindServiceLatest(pcServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pcServiceName), 0).
        
        return cast(lbService.Service, DataObjectService):Catalog.
    end method.
    
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pOperationName as character):
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pOperationName, 'Operation name').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        find first lbOperation where
                   lbOperation.Service eq lbService.Id and
                   lbOperation.Name    eq pOperationName
                   no-error.
        
        return (available lbOperation).
    end method.
    
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character the service name
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pOperationName as character):
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pOperationName, 'Operation name').
        
        FindServiceLatest(pServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pServiceName), 0).
        
        find first lbOperation where
                   lbOperation.Service eq lbService.Id and
                   lbOperation.Name    eq pOperationName
                   no-error.
        
        return (available lbOperation).                                           
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pcServiceName as character,
                                       input pcServiceURI as character,
                                       input poMethod as MethodEnum ):
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Service method').
        
        FindServiceLatest(pcServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pcServiceName), 0).
        
        FindOperationRecord(lbService.Id, pcServiceURI, poMethod, buffer lbOperation).
        
        return (available lbOperation).
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character, 
                                       input pVersion as SemanticVersion,
                                       input pServiceURI as character,
                                       input pMethod as MethodEnum ):
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pServiceURI, 'Service URI').
        Assert:NotNull(pMethod, 'Service method').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        FindOperationRecord(lbService.Id, pServiceURI, pMethod, buffer lbOperation).
        
        return (available lbOperation).                                
    end method.
    
    /* Adds a new operation map for a service.
       
       @param character The service name
       @param SemanticVersion The service version
       @param MappedOperation The operation map for this Method/URI */
    method public void PutOperation(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pMappedOperation as MappedOperation).
        define buffer lbService for Service.
        define buffer lbOperation for Operation.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pMappedOperation, 'Mapped operation').
    
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        FindOperationRecord(lbService.Id, pMappedOperation:ServiceURI, pMappedOperation:Method, buffer lbOperation).
        if not available lbOperation then
        do:
            create lbOperation.
            assign lbOperation.URI     = trim(pMappedOperation:ServiceURI, '/':u)
                   lbOperation.Method  = string(pMappedOperation:Method)
                   lbOperation.Service = lbService.Id
                   .
            if lbOperation.URI eq '':u then
                assign lbOperation.URI = ServiceRegistry:ROOT_SERVICE_URI.
        end.
        
        assign lbOperation.MappedOperation = pMappedOperation
               lbOperation.Name            = pMappedOperation:Name
               .
        Logger:Trace(substitute('Operation map added for &1 &4 &2 &3 (name: &4)',
                                pServiceName, lbOperation.URI, lbOperation.Method, pVersion, lbOperation.Name)).
    end method.

    /* Returns an array or operations for the service 
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations(input pServiceName as character,
                                                       input pVersion as SemanticVersion).
        define variable operations as MappedOperation extent no-undo.
        
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        define query qryOps for lbOperation.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        do on error undo, throw:
            open query qryOps preselect each lbOperation where lbOperation.Service eq lbService.Id.
            assign extent(operations) = query qryOps:num-results no-error.
            get first  qryOps.
            do while available lbOperation:
                assign operations[query qryOps:current-result-row] = cast(lbOperation.MappedOperation, MappedOperation).
                get next qryOps. 
            end.
            
            finally:
                close query qryOps.
                assign error-status:error = no.
            end finally.
        end.
        
        return operations.
    end method.
    
    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.
       
       @param character The service name
       @param SemanticVersion The service version 
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pVersion as SemanticVersion,
                                               input pOperationName as character):
        define variable oOperation as MappedOperation no-undo.
        
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pOperationName, 'Operation name').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        find first lbOperation where
                   lbOperation.Service eq lbService.Id and
                   lbOperation.Name    eq pOperationName
                   no-error.
        if available lbOperation then
            assign oOperation = cast(lbOperation.MappedOperation, MappedOperation).
        
        return oOperation.
    end method.
    
    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.
       
       @param character The service name
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pOperationName as character).
        define variable oOperation as MappedOperation no-undo.
        
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNullOrEmpty(pOperationName, 'Operation name').
        
        FindServiceLatest(pServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pServiceName), 0).
        
        find first lbOperation where
                   lbOperation.Service eq lbService.Id and
                   lbOperation.Name    eq pOperationName
                   no-error.
        if available lbOperation then
            assign oOperation = cast(lbOperation.MappedOperation, MappedOperation).
        
        return oOperation.
    end method.
    
    /* Returns details about the operation  
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pcServiceName as character,
                                               input pcServiceURI as character,
                                               input poMethod as MethodEnum ):
        define variable oOperation as MappedOperation no-undo.
        
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        
        FindServiceLatest(pcServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pcServiceName), 0).
        
        FindOperationRecord(lbService.Id, pcServiceURI, poMethod, buffer lbOperation).
        if available lbOperation then
            assign oOperation = cast(lbOperation.MappedOperation, MappedOperation).
        
        return oOperation.
    end method.
    
    /* Returns details about the operation
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pVersion as SemanticVersion,
                                               input pServiceURI as character,
                                               input pMethod as MethodEnum ).
        define variable oOperation as MappedOperation no-undo.
        
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pServiceURI, 'Service URI').
        Assert:NotNull(pMethod, 'Operation method').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        FindOperationRecord(lbService.Id, pServiceURI, pMethod, buffer lbOperation).
        if available lbOperation then
            assign oOperation = cast(lbOperation.MappedOperation, MappedOperation).
        
        return oOperation.
    end method.
    
    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.  
       
       @param character the service name 
       @param SemanticVersion The service version
       @param character The relative URI    
       @param MethodEnum The HTTP method    */
    method public void RemoveOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pServiceURI as character,
                                       input pMethod as MethodEnum):
        define buffer lbOperation for Operation.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pServiceURI, 'Service relative URL').
        Assert:NotNull(pMethod, 'Http Method').

        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        FindOperationRecord(lbService.Id, pServiceURI, pMethod, buffer lbOperation).
        if available lbOperation then
        do:
            delete lbOperation.
            Logger:Trace(substitute('Operation map removed for "&1 v&4" &2 &3',
                            lbService.ServiceName, lbOperation.URI, lbOperation.Method, pVersion:ToString())).
        end.
    end method.
    
    /* Removes an operation schema from service
       No-op if none exists.  
        
       @param character the service name    
       @param SemanticVersion The service version
       @param character The schema name   */
    method public void RemoveSchema(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pSchemaName as character):
        define buffer lbSchema for DataSchema.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pSchemaName, 'Schema name').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        FindSchemaRecord(lbService.id, pSchemaName, buffer lbSchema).
        
        if available lbSchema then
        do:
            delete object lbSchema.DataStructure no-error.            
            delete lbSchema.
            assign error-status:error = false.
            
            Logger:Trace(substitute('Service schema &2 removed for "&1 v&3"',
                            lbService.ServiceName, lbSchema.SchemaName, pVersion:ToString())).
        end.
    end method.
    
    /* Saves a schema for a given service
       
       @param character The service name
       @param SemanticVersion The service version
       @param character The schema name
       @param handle    An empty data structure (TT or PDS) */
    method public void PutSchema(input pServiceName as character,
                                 input pVersion as SemanticVersion,
                                 input pSchemaName as character,
                                 input pSchema as handle):
        define buffer lbSchema for DataSchema.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pSchemaName, 'Schema name').
        Assert:NotNull(pSchema, 'Schema ').
        
        case pSchema:type:
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                /* NO-OP */
                .
            otherwise
                return error new AppError(substitute('Unsupported schema type: &1', pSchema:type),
                                          0).
        end case.
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        FindSchemaRecord(lbService.Id, pSchemaName, buffer lbSchema).
        
        if not available lbSchema then
        do:
            create lbSchema.
            assign lbSchema.Service    = lbService.Id
                   lbSchema.SchemaName = pSchemaName.
        end.
        else
            delete object lbSchema.DataStructure no-error.
        
        assign lbSchema.DataStructure = pSchema
               // reset the error-status error flag from above
               no-error.
        
        Logger:Trace(substitute('Schema &2 added for service "&1 v&3"',
                        pServiceName, pSchemaName, string(pVersion) )).
    end method.
    
    /* Returns all of the schema names associated with a service .
       
       @param character The service name
       @param SemanticVersion The service version 
       @return character[] An array of service schemas */
    method public character extent GetSchemaNames(input pServiceName as character,
                                                  input pVersion as SemanticVersion):
        define variable schemaName as character extent no-undo.
        
        define buffer lbSchema for DataSchema.
        define buffer lbService for Service.
        define query qrySchema for lbSchema.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, pVersion), 0).
        
        do on error undo, throw:
            open query qrySchema preselect each lbSchema where lbSchema.Service eq lbService.Id.
            assign extent(schemaName) = query qrySchema:num-results no-error.
            get first qrySchema.
            do while available lbSchema:
                assign schemaName[query qrySchema:current-result-row] = lbSchema.SchemaName.
                get next qrySchema. 
            end.
            
            finally:
                close query qrySchema.
                assign error-status:error = no.
            end finally.
        end.
        
        return schemaName.
    end method.
    
    /* Returns a named schema for a latest version of a service.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pcServiceName as character,
                                   input pcSchemaName as character):
        define buffer lbSchema for DataSchema.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcSchemaName, 'Schema name').
        
        FindServiceLatest(pcServiceName, ?, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1"', pcServiceName), 0).
        
        FindSchemaRecord(lbService.Id, pcSchemaName, buffer lbSchema).
        
        if available lbSchema then
            return lbSchema.DataStructure.
        
        return ?.
    end method.
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param SemanticVersion The service version 
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pServiceName as character,
                                   input pVersion as SemanticVersion,
                                   input pSchemaName as character):
        define buffer lbSchema for DataSchema.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pSchemaName, 'Schema name').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).

        FindSchemaRecord(lbService.Id, pSchemaName, buffer lbSchema).
        
        if available lbSchema then
            return lbSchema.DataStructure.
        
        return ?.
    end method.
    
    /* Removes a service registration. No-op of the service + version is not
       registered.
       
       @param character The name of the service to remove from the registry
       @param SemanticVersion The version to deregister */
    method public void DeregisterService(input pServiceName as character,
                                         input pVersion as SemanticVersion):
        define variable svc as DataObjectService no-undo.
        
        define buffer lbService for Service.
        define buffer lbOperation for Operation.
        define buffer lbSchema for DataSchema.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        FindServiceRecord(pServiceName, pVersion, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service "&1 v&2"', pServiceName, string(pVersion)), 0).
        
        assign svc = cast(lbService.Service, DataObjectService). 
        for each lbOperation where
                 lbOperation.Service eq lbService.Id:
            
            Logger:Trace(substitute('Operation map removed for &1 &2 &3',
                            lbService.ServiceName, lbOperation.URI, lbOperation.Method)).
            delete lbOperation.
        end.
        
        for each lbSchema where
                 lbSchema.Service eq lbService.Id:
            Logger:Trace(substitute('Data schema removed for &1 &2',
                            lbService.ServiceName, lbSchema.SchemaName)).    
            
            delete object lbSchema.DataStructure no-error.
            delete lbSchema.                          
        end.
        
        delete lbService.
        
        Logger:Info(substitute('Service "&1" v&2 deregistered', pServiceName, pVersion)).
        
        OnServiceDeregistered(new ServiceRegistryEventArgs(svc)).
        
        // reset the error-status error flag from above
        assign error-status:error = false.
    end method.
    
    /* Helper method to find and position the Service buffer to the latest version of a given service.
       Caller must check availablity themselves.
       
       @param character The service name
       @param SemanticVersion The service version to start at. If none, start at v0.0.0
       @param buffer The Service record to find. */
    method private void FindServiceLatest(input  pServiceName as character,
                                          input  pMinVersion as SemanticVersion,
                                          buffer pService for Service):
        define variable latestVersion as rowid no-undo.
        
        if not valid-object(pMinVersion) then
            assign pMinVersion = new SemanticVersion(0, 0, 0).
        
        VERSION-LOOP:
        for each pService where
                 pService.ServiceName eq pServiceName and
                 pService.Major ge pMinVersion:Major  and
                 pService.Minor ge pMinVersion:Minor  and
                 pService.Patch ge pMinVersion:Patch
                 
                 break by pService.Major descending
                       by pService.Minor descending
                       by pService.Patch descending
                       by pService.PreRelease descending:
            
            if first-of(pService.Patch) then
                // keep the 'highest' value prelease tag; we need to check whether there's an empty tag. 
                assign latestVersion = rowid(pService).
            
            // empty is a 'real release'; beats all pre-release versions
            if pService.PreRelease eq '':u then
            do:
                assign latestVersion = rowid(pService).
                leave VERSION-LOOP.
            end.
            
            if last-of(pService.Patch) then
            do:
                assign latestVersion = rowid(pService).
                leave VERSION-LOOP.
            end.
        end.    //VERSION-LOOP
        
        // find/reposition explicitly. this is so we can clear the buffer if nothing found
        find pService where rowid(pService) eq latestVersion no-error.
    end method.
    
    /* Helper method to find and position the Service buffer to a given service. Caller must check 
       availablity themselves.
       
       Search algo is
       - find match for name + version
       - find match for trim(name, /) + version
       - find latest for name
       - find latest for trim(name, /)
       
       @param character The service name
       @param SemanticVersion The service version
       @param buffer The Service record to find. */
    method private void FindServiceRecord(input  pServiceName as character,
                                          input  pSemVer as SemanticVersion,
                                          buffer pService for Service):
        if valid-object(pSemVer) then
            find pService where
                 pService.ServiceName eq pServiceName  and
                 pService.Major       eq pSemVer:Major and
                 pService.Minor       eq pSemVer:Minor and
                 pService.Patch       eq pSemVer:Patch and
                 pService.PreRelease  eq pSemVer:PreRelease
                 no-error.
        if not available pService 
           and valid-object(pSemVer)
           then
        do:
            find pService where
                 // don't assign trimmed value to variable in case we don't find a record
                 pService.ServiceName eq trim(pServiceName, '/':u) and
                 pService.Major       eq pSemVer:Major             and
                 pService.Minor       eq pSemVer:Minor             and
                 pService.Patch       eq pSemVer:Patch             and
                 pService.PreRelease  eq pSemVer:PreRelease 
                 no-error.
        end.
        
        if not available pService
           and not valid-object(pSemVer)
           then
        do:
            assign pSemVer = new SemanticVersion(0, 0, 0).
            FindServiceLatest(pServiceName, pSemVer, buffer pService).
            if not available pService then
                FindServiceLatest(trim(pServiceName, '/':u), pSemVer, buffer pService).
        end.
    end method.
    
    /* Helper method to find and position the Operation buffer to a given service/method. Caller must check 
       availablity themselves.
       
       @param character The service name
       @param character The service version
       @param character The service URI
       @param MethodEnum the http method
       @param buffer The Operation record to find. */
    method private void FindOperationRecord(input  pcServiceId as character,
                                            input  pcServiceURI as character,
                                            input  poMethod as MethodEnum,
                                            buffer pbOperation for Operation):
        find pbOperation where
             pbOperation.Service eq pcServiceId and
             pbOperation.URI     eq pcServiceURI and
             pbOperation.Method  eq string(poMethod) 
             no-error.
        if available pbOperation then
            return.
        
        assign pcServiceURI  = trim(pcServiceURI, '/':u).
        if pcServiceURI eq '':u then
            assign pcServiceURI = ServiceRegistry:ROOT_SERVICE_URI.
        
        find pbOperation where
             pbOperation.Service eq pcServiceId and
             pbOperation.URI     eq pcServiceURI and
             pbOperation.Method  eq string(poMethod) 
             no-error.
    end method.
    
    /* Helper method to find and position the Service buffer to a given service. Caller must check 
       availablity themselves.
       
       @param character The service name
       @param character The service version
       @param buffer The Service record to find. */
    method  private void FindSchemaRecord(input  pcServiceId as character,
                                          input  pcSchemaName as character,
                                          buffer pbSchema for DataSchema):
        find pbSchema where 
             pbSchema.Service    eq pcServiceId and
             pbSchema.SchemaName eq pcSchemaName   
             no-error.
    end method.
    
    /* Publishes the ServiceRegistered event
       
       @param ServiceRegistryEventArgs The event args */
    method private void OnServiceRegistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Service registry event args').
        this-object:ServiceRegistered:Publish(this-object, poEventArgs).
    end method.
    
    /* Publishes the ServiceDeregistered event
       
       @param ServiceRegistryEventArgs The event args */
    method private void OnServiceDeregistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Service registry event args').
        this-object:ServiceDeregistered:Publish(this-object, poEventArgs).
    end method.
    
end class.
