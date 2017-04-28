/************************************************
  Copyright (c) 2017 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Security.PAMStatusEnum.
using OpenEdge.Security.Principal.
using OpenEdge.Security.Provider.UserTablePolicyProvider.
using OpenEdge.Security.STS.IPolicyProvider.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Security.Provider.UserTablePolicyProvider implements IPolicyProvider, ISupportLogging:
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(UserTablePolicyProvider)).
                
            return this-object:Logger. 
        end get.
        set.
    
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
        define buffer bUser for STSDB._User.
        
        case pcPolicyName:
            when 'TOKEN-AUTHENTICATE':u then
            do:
                define variable splitUser as character extent 2 no-undo.
                
                assign splitUser[1] = entry(1, poPrincipal:Token:user-id, '@':u)
                       splitUser[2] = entry(2, poPrincipal:Token:user-id, '@':u)
                       no-error.
                
                Assert:NotNullOrEmpty(splitUser[1], 'User id').
                Assert:NotNull(splitUser[2], 'User domain').
                
                // find user in _User
                find bUser where
                     bUser._Userid      eq splitUser[1] and
                     bUser._Domain-Name eq splitUser[2]
                     no-lock no-error.
                if not available bUser then
                do:
                    Logger:Debug(substitute('Unknown user &1', poPrincipal:Token:user-id)).
                    return error new AppError('User not found', 0).
                end.
                
                // check sql-only flag. If the user's SQL-only flag is TRUE then the clientType MUST be HLI
                if not (bUser._sql-only-user and poDomainCtx:GetCharacter('clientType':u) eq 'HLI':u)  then 
                    return PAMStatusEnum:LoginDenied.
            end.
        end case.
        
        /* The _USER table auth system in the database config is called _oeusertable.
           There are some dependencies on that in the AVM. */
        if poPrincipal:Token:seal-timestamp eq ? then
            assign poPrincipal:Token:domain-type = '_oeusertable':u.
        
        return PAMStatusEnum:Success.
    end method.
    
end class.