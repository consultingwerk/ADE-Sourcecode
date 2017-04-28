/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IPolicyProvider
    Purpose     : Defines an interface for interacting with a Policy Provider 
                  from an STS 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 27 16:09:05 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Security.PAMStatusEnum.
using OpenEdge.Security.Principal.
using Progress.Json.ObjectModel.JsonObject.

interface OpenEdge.Security.STS.IPolicyProvider:
    /* Applies a policy
       
       @param character  (mandatory) The sender of the event
       @param character  (mandatory) The name of the policy event 
       @param Principal  (mandatory)The client-principal/token currently being processed in the STS. 
                         Modifications to the contained Token will be returned to the STS.
       @param JsonObject (optional) A collection of options and operations supported by the domain  
       @param character out (optional) Status detail text
       @return PAMStatusEnum (optional) A new status for the CP based on the policy */
    method public PAMStatusEnum ApplyPolicy (input  pcSender as character,
                                             input  pcPolicyName as character,
                                             input  poPrincipal as Principal,
                                             input  poDomainCtx as JsonObject,
                                             output pcStatusDetail as character).
    
end interface.