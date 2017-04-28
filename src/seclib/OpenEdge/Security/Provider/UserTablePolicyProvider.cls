/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UserTablePolicyProvider
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 09 16:07:29 EST 2016
    Notes       :
    @since 11.7.0 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Security.PAMStatusEnum.
using OpenEdge.Security.Principal.
using OpenEdge.Security.STS.IPolicyProvider.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Security.Provider.UserTablePolicyProvider implements IPolicyProvider: 
    /* Applies a policy
       
       @param character  (mandatory) The sender of the event
       @param character  (mandatory) The name of the policy event 
       @param Principal  (mandatory)The client-principal/token currently being processed in the STS. 
                         Modifications to the contained Token will be returned to the STS.
       @param JsonObject (optional) A collection of options and operations supported by the domain  
       @param character out (optional) Status detail text
       @return PAMStatusEnum (optional) A new status for the CP based on the policy */
	method public PAMStatusEnum ApplyPolicy(input  pcSender as character,
                	                        input  pcPolicyName as character,
                	                        input  poPrincipal as Principal,
                	                        input  poDomainCtx as JsonObject,
                	                        output pcStatusDetail as character ):
        case pcPolicyName:
            when 'TOKEN-AUTHENTICATE':U then
            do:
                // find user in _User
                    // check sql-only flag
                    // if client=SQL & flag=false, return PAMStatusEnum:LoginDenied
                
            end.                
            otherwise
                /* The _USER table auth system in the database config is called _oeusertable.
                   There are some dependencies on that in the AVM. */
                if poPrincipal:Token:seal-timestamp eq ? then
                    assign poPrincipal:Token:DOMAIN-TYPE = '_oeusertable':u.
        end case.
        
        return PAMStatusEnum:Success.
	end method.
	
end class.