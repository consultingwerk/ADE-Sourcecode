/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistry
    Purpose     : Static implementation of the service registry 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : * static members let multiple DataObjectHandler instances use this
                  * The actual work is done in the Instance of ServiceRegistryImpl
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.ServiceRegistryEventArgs.
using OpenEdge.Web.DataObject.ServiceRegistryImpl.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.ServiceRegistry abstract:
    // Holds the class that does the actual work/maintains the actual registry
    define static private property Instance as ServiceRegistryImpl no-undo
        get():
            if not valid-object(ServiceRegistry:Instance) then
                assign ServiceRegistry:Instance = new ServiceRegistryImpl().
            
            return ServiceRegistry:Instance.
        end get.
        set.
    
    /* Event published when a a service has been registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event ServiceRegistered signature void (input poSender as Progress.Lang.Object,
                                                                 input poEventArgs as ServiceRegistryEventArgs).

    /* Event published when a a service has been de-registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event ServiceDeregistered signature void (input poSender as Progress.Lang.Object,
                                                                   input poEventArgs as ServiceRegistryEventArgs).

    // The default name for the root (unnamed) service
    define static public property ROOT_SERVICE_NAME as character init 'ROOT':u no-undo get.
    
    // The root uur (ie / ) 
    define static public property ROOT_SERVICE_URI  as character init '/':u no-undo get.
    
    /* Indicates whether a named service is available. Will attempt to 
       locate a service map if it is not yet registered, and will register
       it if one can be found. The search path for finding the service mapping
       files is
       
       1. Look in the webapp's WEB-INF/openedge folder first
       2. Look in the instance's /openedge folder next
       3. Look in the rest of PROPATH  
       
       @param character The name of the mapped service
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method static public logical TryFindService(input pcServiceName as character,
                                                input pcWebAppPath as character):
        return Instance:TryFindService(pcServiceName, pcWebAppPath).
    end method.
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method static public logical HasService(input pcServiceName as character):
        return Instance:HasService(pcServiceName).
    end method.
    
    /* Returns all registered service names 
       
       @return character extent An array of registered services. indeterminate if none. */
    method static public integer GetServices(output pcServices as character extent):
        return Instance:GetServices(output pcServices).
    end method.

    /* Sets the service options for a named service 
       
       @param character The service name. 
       @param JsonObject  A JSON object containing options. 
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public void PutServiceOptions(input pcServiceName as character,
                                                input poOptions as JsonObject):
        Instance:PutServiceOptions(pcServiceName, poOptions).                                                    
    end method.
        
    /* Returns the service options for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO object containing options. If no exist or none can be 
                           found, return an empty JSON object.
       @throws AssertionFailedError If the name is empty or null */
    method static public JsonObject GetServiceOptions(input pcServiceName as character):
        return Instance:GetServiceOptions(pcServiceName).
    end method.
    
    /* Sets a catalog for a named service 
       
       @param character The service name. 
       @param JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public void PutServiceCatalog(input pcServiceName as character,
                                                input poCatalog as JsonObject):
        Instance:PutServiceCatalog(pcServiceName, poCatalog).
    end method.         
    
    /* Returns a catalog for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public JsonObject GetServiceCatalog(input pcServiceName as character):
        return Instance:GetServiceCatalog(pcServiceName).
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method static public logical HasOperation(input pcServiceName as character,
                                              input pcServiceURI as character,
                                              input poMethod as MethodEnum ):
        return Instance:HasOperation(pcServiceName, pcServiceURI, poMethod).                                                  
    end method.
    
    /* Adds a new operation map for a service.
       
       @param character The service name
       @param MappedOperation The operation map for this Method/URI */
    method static public void PutOperation(input pcServiceName as character,
                                           input poMappedOperation as MappedOperation):
        Instance:PutOperation(pcServiceName, poMappedOperation).
    end method.
    
    /* Returns details about the operation  
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method static public MappedOperation GetOperation(input pcServiceName as character,
                                                      input pcServiceURI as character,
                                                      input poMethod as MethodEnum ):
        return Instance:GetOperation(pcServiceName, pcServiceURI, poMethod).                                                          
    end method.
              
    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.  
       
       @param character the service name 
       @param character The relative URI    
       @param MethodEnum The HTTP method    */
    method static public void RemoveOperation(input pcServiceName as character,
                                              input pcServiceURI as character,
                                              input poMethod as MethodEnum):
        Instance:RemoveOperation(pcServiceName, pcServiceURI, poMethod).                                                  
    end method.

    /* Removes an operation schema from service
       No-op if none exists.  
        
       @param character the service name    
       @param character The schema name   */
    method static public void RemoveSchema(input pcServiceName as character,
                                           input pcSchemaName as character):
        Instance:RemoveSchema(pcServiceName, pcSchemaName).
    end method.
    
    /* Saves a schema for a given service
       
       @param character The service name
       @param character The schema name
       @param handle    An empty data structure (TT or PDS) */
    method static public void PutSchema(input pcServiceName as character,
                                        input pcSchemaName as character,
                                        input phSchema as handle):
        Instance:PutSchema(pcServiceName, pcSchemaName, phSchema). 
    end method.
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method static public handle GetSchema(input pcServiceName as character,
                                          input pcSchemaName as character):
        return Instance:GetSchema(pcServiceName, pcSchemaName).
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
        Instance:RegisterService(pcServiceName,
                                 pcVersion,
                                 poOperations,
                                 poCatalog,
                                 poSchemas  ).
        OnServiceRegistered(new ServiceRegistryEventArgs(pcServiceName)).                                 
    end method.
    
    /* Removes a service registration.
       
       @param character The name of the service to remove from the registry */
    method static public void DeregisterService(input pcServiceName as character):
        Instance:DeregisterService(pcServiceName).
        OnServiceDeregistered(new ServiceRegistryEventArgs(pcServiceName)).        
    end method.
    
    /* Registers all services found in a given file. Can be used at agent startup
       
       @param character An extant file */
    method static public void RegisterFromFile(input pcFile as character):
        Instance:RegisterFromFile(pcFile).
     end method.

    /* Registers a named service found in a given file. Can be used at agent startup
       
       @param character A service name
       @param character An extant file */
    method static public void RegisterFromFile(input pcServiceName as character,
                                               input pcFile as character):
        Instance:RegisterFromFile(pcServiceName, pcFile).                                                   
     end method.

    /* Registers all services found in a given folder. Can be used at agent startup
       
       @param character An extant folder */
    method static public void RegisterAllFromFolder(input pcFolder as character):
        Instance:RegisterAllFromFolder(pcFolder).
    end method.
    
    /* Publishes the ServiceRegistered event
       
       @param ServiceRegistryEventArgs The event args */
    method static private void OnServiceRegistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        ServiceRegistry:ServiceRegistered:Publish(get-class(ServiceRegistry), poEventArgs).
    end method.                                              

    /* Publishes the ServiceDeregistered event
       
       @param ServiceRegistryEventArgs The event args */
    method static private void OnServiceDeregistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        ServiceRegistry:ServiceDeregistered:Publish(get-class(ServiceRegistry), poEventArgs).
    end method.
    
end class.