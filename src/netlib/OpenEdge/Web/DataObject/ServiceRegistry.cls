/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistry
    Purpose     : Static implementation wrappeter around a service registry 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : * static members let multiple DataObjectHandler instances use this
                  * The actual work is done in the Registry of ServiceRegistryImpl
                  * Load-from-JSON is done in the Loader (ServiceRegistryLoader)
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.SemanticVersion.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.ServiceRegistryImpl.
using OpenEdge.Web.DataObject.ServiceRegistryLoader.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.ServiceRegistry abstract:
    
    /* Holds the class that does loads from JSON into the registry */
    define static public property Loader as ServiceRegistryLoader no-undo
        get():
            // Use a CCS Service Manager if extant, and let it control this object's lifecycle
            if valid-object(Ccs.Common.Application:ServiceManager) then
                assign ServiceRegistry:Loader = cast(Ccs.Common.Application:ServiceManager
                                                            :getService(get-class(ServiceRegistryLoader)),
                                                       ServiceRegistryLoader).
            
            if not valid-object(ServiceRegistry:Loader) then
                assign ServiceRegistry:Loader= new ServiceRegistryLoader(ServiceRegistry:Registry).
            
            return ServiceRegistry:Loader.
        end get.
        private set.
    
    // Holds the class that does the actual work/maintains the actual registry
    define static public property Registry as IServiceRegistry no-undo
        get():
            // Use a CCS Service Manager if extant, and let it control this object's lifecycle
            if valid-object(Ccs.Common.Application:ServiceManager) then
                assign ServiceRegistry:Registry = cast(Ccs.Common.Application:ServiceManager
                                                            :getService(get-class(IServiceRegistry)),
                                                       IServiceRegistry).
            
            if not valid-object(ServiceRegistry:Registry) then
                assign ServiceRegistry:Registry = new ServiceRegistryImpl().
            
            return ServiceRegistry:Registry.
        end get.
        private set.
    
    // The default name for the root (unnamed) service
    define static public property ROOT_SERVICE_NAME as character no-undo
        get():
            return DataObjectService:ROOT_SERVICE_NAME.
        end get.
    
    // The root uri (ie / ) 
    define static public property ROOT_SERVICE_URI as character
        get():
            return DataObjectService:ROOT_SERVICE_URI.
        end get.
    
    /* Default constructor. Private to prevent instantiation */
    constructor private ServiceRegistry():
    end constructor.
    
    /* Indicates whether a named service is available. Will attempt to 
       locate a service map if it is not yet registered, and will register
       it if one can be found. 
       
       @param character The name of the mapped service
       @param character A version of the service to load
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method static public logical TryFindService(input pcServiceName as character,
                                                input pVersion as character,
                                                input pcWebAppPath as character):
        return Loader:TryFindService(pcServiceName, pVersion, pcWebAppPath).
    end method.

    /* Indicates whether a named service is available. Will attempt to 
       locate a service map if it is not yet registered, and will register
       it if one can be found. 
       
       @param character The name of the mapped service
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method static public logical TryFindService(input pcServiceName as character,
                                                input pcWebAppPath as character):
        return Loader:TryFindService(pcServiceName, pcWebAppPath).
    end method.
        
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @param character The service version
       @return logical TRUE if the service exists */
    method static public logical HasService(input pServiceName as character,
                                     input pVersion as character):
        return Registry:HasService(pServiceName, pVersion).
    end method.
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method static public logical HasService(input pcServiceName as character):
        return Registry:HasService(pcServiceName).
    end method.
    
    /* Returns a the latest version of a service 
       
       @param character The name of the service to remove from the registry
       @return DataObjectService  A data service 'header' */
    method static public DataObjectService GetService(input pServiceName as character):
        return Registry:GetService(pServiceName).
    end method.
            
    /* Returns a service object
       
       @param character The name of the service to remove from the registry
       @param character The service version to retrieve
       @return DataObjectService  A data service 'header' */
    method static public DataObjectService GetService(input pServiceName as character,
                                                      input pVersion as character).
        return Registry:GetService(pServiceName, pVersion).
    end method.
    
    /* Returns all registered services
       
       @return DataObjectService[] extent An array of registered services. indeterminate if none. */
    method static public DataObjectService extent GetServices().
        return Registry:GetServices().
    end method.
    
    /* Returns the service options for a named service 
       
       @param character The service name. 
       @return ServiceOptions  A JSDO object containing options. If no exist or none can be 
                           found, return an empty JSON object.
       @throws AssertionFailedError If the name is empty or null */
    method static public ServiceOptions GetServiceOptions(input pcServiceName as character):
        return Registry:GetServiceOptions(pcServiceName).
    end method.
    
    /* Returns a catalog for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public JsonObject GetServiceCatalog(input pcServiceName as character):
        return Registry:GetServiceCatalog(pcServiceName).
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method static public logical HasOperation(input pcServiceName as character,
                                              input pcServiceURI as character,
                                              input poMethod as MethodEnum ):
        return Registry:HasOperation(pcServiceName, pcServiceURI, poMethod).
    end method.
    
    /* Returns details about the operation  
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method static public MappedOperation GetOperation(input pcServiceName as character,
                                                      input pcServiceURI as character,
                                                      input poMethod as MethodEnum ):
        return Registry:GetOperation(pcServiceName, pcServiceURI, poMethod).
    end method.
              
    /* Returns an array or operations for the service 
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations(input pServiceName as character,
                                                       input pVersion as SemanticVersion):
        return Registry:GetOperations(pServiceName, pVersion).
    end method.
    
    /* Returns details about the operation
       
       @param character The serviceName
       @param SemanticVersion The service version 
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method static public MappedOperation GetOperation(input pServiceName as character,
                                                      input pVersion as SemanticVersion,
                                                      input pServiceURI as character,
                                                      input pMethod as MethodEnum ):
        return Registry:GetOperation(pServiceName, pVersion, pServiceURI, pMethod).
    end method.
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method static public handle GetSchema(input pcServiceName as character,
                                          input pcSchemaName as character):
        return Registry:GetSchema(pcServiceName, pcSchemaName).
    end method.
    
    /* Register a service in this handler.
    
       @param character  (mandatory) The service name.
       @param JsonObject (recommended) An operation map for the service.
       @param JsonObject (optional) A catalog for the service. Optional since it may exist on disk */
    method static public void RegisterService(input pcServiceName  as character,
                                              input pcVersion as character,
                                              input poOperations as JsonObject,
                                              input poCatalog as JsonObject,
                                              input poSchemas as JsonObject ):
        Loader:RegisterService(pcServiceName,
                               pcVersion,
                               poOperations,
                               poCatalog,
                               poSchemas  ).
    end method.
    
    /* Registers all services found in a given file. Can be used at agent startup
       
       @param character An extant file */
    method static public void RegisterFromFile(input pcFile as character):
        Loader:RegisterFromFile(pcFile).
     end method.

    /* Registers a named service found in a given file. Can be used at agent startup
       
       @param character A service name
       @param character An extant file */
    method static public void RegisterFromFile(input pcServiceName as character,
                                               input pcFile as character):
        Loader:RegisterFromFile(pcServiceName, pcFile).                                                   
     end method.

    /* Registers all services found in a given folder. Can be used at agent startup
       
       @param character An extant folder */
    method static public void RegisterAllFromFolder(input pcFolder as character):
        Loader:RegisterAllFromFolder(pcFolder).
    end method.
    
end class.