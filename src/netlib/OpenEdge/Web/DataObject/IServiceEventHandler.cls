/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IServiceEventHandler
    Purpose     : Signatures for the DataObjectHandler Service-level events
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-08-17
    Notes       : * Classes that want to receive the DOH's messages MUST
                    implement this interface
  ----------------------------------------------------------------------*/
using OpenEdge.Web.DataObject.ServiceDiscoveryEventArgs.

interface OpenEdge.Web.DataObject.IServiceEventHandler:
    
    /* Event handler for service discovery
       
       @param Progress.Lang.Object The handler publishing the event
       @param ServiceLookupEventArgs Event args for this event */
    method public void DiscoverServiceHandler(input pSender as Progress.Lang.Object,
                                              input pEventArgs as ServiceDiscoveryEventArgs).
    
end interface.