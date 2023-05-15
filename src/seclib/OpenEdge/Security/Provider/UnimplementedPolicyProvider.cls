/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UnimplementedPolicyProvider
    Purpose     : A default implementation intended to signal to a STS admin that a 'real' 
                  implementation is missing. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 12 19:32:05 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Security.PAMStatusEnum.
using OpenEdge.Security.Principal.
using OpenEdge.Security.STS.IPolicyProvider.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Security.Provider.UnimplementedPolicyProvider implements IPolicyProvider: 
    /* Applies a policy
       
       @param character  (mandatory) The sender of the event
       @param character  (mandatory) The name of the policy event 
       @param Principal  (mandatory)The client-principal/token currently being processed in the STS. 
                         Modifications to the contained Token will be returned to the STS.
       @param JsonObject (optional) A collection of options and operations supported by the domain  
       @param character out (optional) Status detail text
       @return PAMStatusEnum (optional) A new status for the CP based on the policy */
    {&_proparse_ prolint-nowarn(varusage)}
    method public PAMStatusEnum ApplyPolicy (input  pcSender as character,
                                             input  pcPolicyName as character,
                                             input  poPrincipal as Principal,
                                             input  poDomainCtx as JsonObject,
                                             output pcStatusDetail as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cOptions as character no-undo.
        
        if valid-object(poDomainCtx) and
           poDomainCtx:Has('domainContext':u) then
        do:
            log-manager:write-message(substitute('Unimplemented policy provider for domain: &1', 
                                            poPrincipal:Token:domain-name),
                            'STSPOLCY':u).    

            assign cOptions = poDomainCtx:GetCharacter('domainContext':u)
                   iMax = num-entries(cOptions).
            CALLBLK:
            do iLoop = 1 to iMax:
                if entry(iLoop, cOptions) begins 'PAMCallback=':u then
                do:
                    log-manager:write-message(substitute('Unimplemented PAM Callback: &1', 
                                                    quoter(entry(iLoop, cOptions))),
                                    'STSPOLCY':u).    
                    leave CALLBLK.
                end.
            end.
        end.
        
		return PAMStatusEnum:InvalidConfiguration.
	end method.

end class.