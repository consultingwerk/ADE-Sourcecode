/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceOptions.
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
        field ParentRegistry as int64
        field ServiceName as character case-sensitive
        field Major as integer
        field Minor as integer
        field Patch as integer
        field PreRelease as character
        //DATA
        field Service           as Progress.Lang.Object     // OpenEdge.Web.DataObject.DataObjectService
        
        // for finding
        index idx1 as primary unique ParentRegistry ServiceName Major Minor Patch PreRelease
        .
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /* Default constructor */
    constructor public ServiceRegistryImpl():
        assign // Note that it's NOT the ServiceRegistryImpl type
               this-object:Logger = LoggerBuilder:GetLogger(get-class(IServiceRegistry)).
    end constructor.
    
    /* Destructor */
    destructor ServiceRegistryImpl():
        define buffer lbService for Service.
        
        // Publish the deregistration
        for each lbService where lbService.ParentRegistry eq int64(this-object):
            DeregisterService(cast(lbService.Service, DataObjectService):Name, cast(lbService.Service, DataObjectService):Version).
        end.
    end destructor.
    
    /* Adds a service to this registry
       
       @param DataObjectService  A data service object */
    method public void RegisterService(input pService as DataObjectService):
        define buffer lbService for Service.
        
        Assert:NotNull(pService, 'Service').
        
        // Name is already normalised in the DOS instance
        FindServiceRecord(pService:Name, pService:Version, buffer lbService).
        if not available lbService then
        do:
            create lbService.
            assign lbService.ParentRegistry = int64(this-object)
                   lbService.ServiceName    = pService:Name
                   lbService.Major          = pService:Version:Major
                   lbService.Minor          = pService:Version:Minor
                   lbService.Patch          = pService:Version:Patch
                   lbService.PreRelease     = pService:Version:PreRelease
                   lbService.Service        = pService
                   .
            OnServiceRegistered(new ServiceRegistryEventArgs(pService)).
            Logger:Info(substitute('Service "&1 v&2" registered', pService:Name, string(pService:Version))).
        end.
    end method.
    
    /* Register a service 
       
       @param character  (mandatory) The service name
       @param SemanticVersion  (mandatory) The service version
       @param ServiceOptions (optional) A set of options for the service
       @param JsonObject (optional) A catalog for the service. Not all services have catalogs 
       @return DataObjectService  The (registered) data service */
    method public DataObjectService RegisterService(input pServiceName  as character,
                                                    input pVersion as SemanticVersion,
                                                    input pOptions as ServiceOptions,
                                                    input pCatalog as JsonObject).                                           
        define variable svc as DataObjectService no-undo.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        assign svc         = new DataObjectService(pServiceName, pVersion)
               /* these can both be can be unknown */
               svc:Options = pOptions
               svc:Catalog = pCatalog
               .
        RegisterService(svc).
        
        return svc.
    end method.
    
    /* Indicates whether a named, versioned service is available in the registry.  
       
       @param character The name of the mapped service
       @param SemanticVersion The service version
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character,
                                     input pVersion as SemanticVersion):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        if valid-object(pVersion) then
            FindServiceRecord(DataObjectService:NormaliseServiceName(pServiceName),
                              pVersion,
                              buffer lbService).
        else
            FindServiceLatest(DataObjectService:NormaliseServiceName(pServiceName),
                              ?,        // version
                              buffer lbService).
        
        return (available lbService).
    end method.
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method public logical HasService(input pServiceName as character):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        FindServiceLatest(DataObjectService:NormaliseServiceName(pServiceName),
                          ?,
                          buffer lbService).
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
        
        if pVersion eq '':u then
            FindServiceLatest(DataObjectService:NormaliseServiceName(pServiceName),
                              ?,        // version
                              buffer lbService).
        else
            FindServiceRecord(DataObjectService:NormaliseServiceName(pServiceName),
                              SemanticVersion:Parse(pVersion),
                              buffer lbService).
        
        return (available lbService).
    end method.
    
    /* Returns a the latest version of a service 
       
       @param character The name of the service to remove from the registry
       @return DataObjectService  A data service 'header' */
    method public DataObjectService GetService(input pServiceName as character):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        FindServiceLatest(DataObjectService:NormaliseServiceName(pServiceName),
                          ?,        // version
                          buffer lbService).
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
        if pVersion eq '':u then
            return GetService(pServiceName).
        else
            return GetService(pServiceName, SemanticVersion:Parse(pVersion)).
    end method.
    
    /* Returns a versioned service. If this exact version is not found, then error
       
       @param character The name of the service to find
       @param SemanticVersion The service version to retrieve
       @return DataObjectService  A data service  */
    method public DataObjectService GetService(input pServiceName as character,
                                               input pVersion as SemanticVersion):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        // return latest
        FindServiceRecord(DataObjectService:NormaliseServiceName(pServiceName),
                          pVersion,
                          buffer lbService).
        
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
        
        open query qryService preselect each lbService where lbService.ParentRegistry eq int64(this-object).
        
        if query qryService:num-results gt 0 then
            assign extent(services) = query qryService:num-results.
        
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
                               lbService.ParentRegistry eq int64(this-object) and
                               lbService.ServiceName    eq DataObjectService:NormaliseServiceName(pServiceName)
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
        assign GetService(pServiceName, pVersion):Options = pOptions.
    end method.
    
    /* Returns the service options for a named service 
       
       @param character The service name. 
       @return ServiceOptions  The service options.
       @throws AssertionFailedError If the name is empty or null 
       @throws AppError If the service is not registered */
    method public ServiceOptions GetServiceOptions(input pcServiceName as character):
        return GetService(pcServiceName):Options.
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
        assign GetService(pServiceName, pVersion):Catalog = pCatalog. 
    end method.
    
    /* Returns a catalog for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method public JsonObject GetServiceCatalog(input pcServiceName as character):
        return GetService(pcServiceName):Catalog.
    end method.
    
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pVersion as SemanticVersion,
                                       input pOperationName as character):
        return GetService(pServiceName, pVersion):HasOperation(pOperationName).
    end method.
    
    /* Indicates whether a mapped operation exists with a given name  
       
       @param character the service name
       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceName as character,
                                       input pOperationName as character):
        return GetService(pServiceName):HasOperation(pOperationName).
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pcServiceName as character,
                                       input pcServiceURI as character,
                                       input poMethod as MethodEnum ):
        return GetService(pcServiceName):HasOperation(pcServiceURI, poMethod).
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
        return GetService(pServiceName, pVersion):HasOperation(pServiceURI, pMethod).
    end method.
    
    /* Adds a new operation map for a service.
       
       @param character The service name
       @param SemanticVersion The service version
       @param MappedOperation The operation map for this Method/URI */
    method public void PutOperation(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pMappedOperation as MappedOperation).
        define variable svc as DataObjectService no-undo.
        
        assign svc = GetService(pServiceName, pVersion).
        svc:PutOperation(pMappedOperation).
        
        Logger:Trace(substitute('Operation map added for &1 &4 &2 &3 (name: &5)',
                                svc:Name, pMappedOperation:ServiceURI, string(pMappedOperation:Method), string(svc:Version), pMappedOperation:Name)).
    end method.

    /* Returns an array or operations for the service 
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations(input pServiceName as character,
                                                       input pVersion as SemanticVersion).
        return GetService(pServiceName, pVersion):GetOperations().
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
        return GetService(pServiceName, pVersion):GetOperation(pOperationName).
    end method.
    
    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.
       
       @param character The service name
       @param character An optional name for the operation 
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pServiceName as character,
                                               input pOperationName as character).
        return GetService(pServiceName):GetOperation(pOperationName).
    end method.
    
    /* Returns details about the operation  
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pcServiceName as character,
                                               input pcServiceURI as character,
                                               input poMethod as MethodEnum ):
        return GetService(pcServiceName):GetOperation(pcServiceURI, poMethod).
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
        return GetService(pServiceName, pVersion):GetOperation(pServiceURI, pMethod).
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
        define variable svc as DataObjectService no-undo.
        
        assign svc = GetService(pServiceName, pVersion).
        
        svc:RemoveOperation(pServiceURI, pMethod).
        Logger:Trace(substitute('Operation map removed for "&1 v&4" &2 &3',
                        svc:Name, pServiceURI, pMethod:ToString(), svc:Version:ToString())).
    end method.
    
    /* Indicates whether a schema exists with a given name  
       
       @param character the service name
       @param SemanticVersion The service version 
       @param character The schema name
       @return logical TRUE if the schema exists */
    method public logical HasSchema(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pSchemaName as character):
        return GetService(pServiceName, pVersion):HasSchema(pSchemaName).
    end method.
    
    /* Indicates whether a schema exists with a given name  
       
       @param character the service name
       @param character The schema name
       @return logical TRUE if the schema exists */
    method public logical HasSchema(input pServiceName as character,
                                    input pSchemaName as character):
        return GetService(pServiceName):HasSchema(pSchemaName).
    end method.
    
    /* Removes an operation schema from service
       No-op if none exists.  
        
       @param character the service name    
       @param SemanticVersion The service version
       @param character The schema name   */
    method public void RemoveSchema(input pServiceName as character,
                                    input pVersion as SemanticVersion,
                                    input pSchemaName as character):
        define variable svc as DataObjectService no-undo.
        
        assign svc = GetService(pServiceName, pVersion).
        
        svc:RemoveSchema(pSchemaName).
        Logger:Trace(substitute('Service schema &2 removed for "&1 v&3"',
                            svc:Name, pSchemaName, svc:Version:ToString())).
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
        define variable svc as DataObjectService no-undo.
        
        assign svc = GetService(pServiceName, pVersion).
        
        svc:PutSchema(pSchemaName, pSchema).
        Logger:Trace(substitute('Schema &2 added for service "&1 v&3"',
                        svc:Name, pSchemaName, string(svc:Version) )).
    end method.
    
    /* Returns all of the schemas associated with the latest version of a service.
       
       @param character The service name
       @param SemanticVersion The service version 
       @return handle[] An array of service schemas */
    method public handle extent GetSchemas(input pServiceName as character,
                                           input pVersion as SemanticVersion):
        return GetService(pServiceName, pVersion):GetSchemas().
    end method.
    
    /* Returns a named schema for a latest version of a service.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pcServiceName as character,
                                   input pcSchemaName as character):
        return GetService(pcServiceName):GetSchema(pcSchemaName).
    end method.
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param SemanticVersion The service version 
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pServiceName as character,
                                   input pVersion as SemanticVersion,
                                   input pSchemaName as character):
        return GetService(pServiceName, pVersion):GetSchema(pSchemaName).
    end method.
    
    /* Removes a service registration. No-op of the service + version is not
       registered.
       
       @param character The name of the service to remove from the registry
       @param SemanticVersion The version to deregister */
    method public void DeregisterService(input pServiceName as character,
                                         input pVersion as SemanticVersion):
        define variable svc as DataObjectService no-undo.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pServiceName, 'Service name').
        
        FindServiceRecord(DataObjectService:NormaliseServiceName(pServiceName),
                          pVersion,
                          buffer lbService).
        if not available lbService then
        do:
            Logger:Warn(substitute('Unable to find service "&1 v&2" for deregistration', pServiceName, string(pVersion))).
            return.
        end.
        
        assign svc = cast(lbService.Service, DataObjectService).
        
        delete lbService.
        
        Logger:Info(substitute('Service "&1" v&2 deregistered', pServiceName, string(pVersion))).
        
        OnServiceDeregistered(new ServiceRegistryEventArgs(svc)).
    end method.
    
    /* Helper method to find and position the Service buffer to the latest version of a given service.
       Caller must check availablity themselves.
       
       @param character The service name (normalised - no-/, not-empty)
       @param SemanticVersion The service version to start at. If none, start at v0.0.0
       @param buffer The Service record to find. */
    method private void FindServiceLatest(input  pServiceName as character,
                                          input  pMinVersion as SemanticVersion,
                                          buffer pService for Service):
        define variable latestVersion as rowid no-undo.
        
        // 'let go' of the record so that the AVAILABLE status is always correct
        release pService.
        
        if not valid-object(pMinVersion) then
            assign pMinVersion = new SemanticVersion(0, 0, 0).
        
        assign latestVersion = ?.
        VERSION-LOOP:
        for each pService where
                 pService.ParentRegistry eq int64(this-object) and
                 pService.ServiceName    eq pServiceName       and
                 pService.Major          ge pMinVersion:Major  and
                 pService.Minor          ge pMinVersion:Minor  and
                 pService.Patch          ge pMinVersion:Patch
                 
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
        if not latestVersion eq ? then 
            find pService where rowid(pService) eq latestVersion.
    end method.
    
    /* Helper method to find and position the Service buffer to a given service+version. Caller must check 
       availablity themselves.
       
       For unknown/unsure versions, use FindServiceLatest() 
       
       @param character The service name
       @param SemanticVersion The service version
       @param buffer The Service record to find. */
    method private void FindServiceRecord(input  pServiceName as character,
                                          input  pSemVer as SemanticVersion,
                                          buffer pService for Service):
        // 'let go' of the record so that the AVAILABLE status is always correct
        release pService.
        
        if     valid-object(pSemVer)
           and can-find( pService where
                         pService.ParentRegistry eq int64(this-object) and
                         pService.ServiceName    eq pServiceName       and
                         pService.Major          eq pSemVer:Major      and
                         pService.Minor          eq pSemVer:Minor      and
                         pService.Patch          eq pSemVer:Patch      and
                         pService.PreRelease     eq pSemVer:PreRelease      )
        then
            find pService where
                 pService.ParentRegistry eq int64(this-object) and
                 pService.ServiceName    eq pServiceName       and
                 pService.Major          eq pSemVer:Major      and
                 pService.Minor          eq pSemVer:Minor      and
                 pService.Patch          eq pSemVer:Patch      and
                 pService.PreRelease     eq pSemVer:PreRelease.
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
