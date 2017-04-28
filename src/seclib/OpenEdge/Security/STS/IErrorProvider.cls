/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IErrorProvider
    Purpose     : Defines an interface for interacting with a Error Provider 
                  from an STS 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 04 10:32:27 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.URI.
using OpenEdge.Security.Principal.
using Progress.Json.ObjectModel.JsonObject.

interface OpenEdge.Security.STS.IErrorProvider:
    
    /* handles/customises an error 
       
       @param character (mandatory) The sender of the event
       @param character (mandatory) The name of the policy event 
       @param Principal (optional) The failed sealed CP, if available, for informational purposes
       @param character (optional) An error string indicating the error being handled. Could be a java exception or 
                                   something from an auth proivider, or empty. One of the client-principal and error-string 
                                   fields SHOULD be provided
       @param JsonObject (optional) A collection of options and operations supported by the domain  
       @param character out (optional) An error code per the OAuth2 and OpenId Connect specs. To return an 
                                       error number a string of custom:<error_code> must be returned. If not empty or null,
                                       this value will replace the auth process's error value.
       @param character out (optional) If blank or unknown the response will omit the error_description field.
       @param URI out (optional) If null the response will omit the error_uri field.
       @return logical TRUE if the current token should be included in the error response */
    method public logical HandleError (input  pcSender as character,
                                       input  pcPolicyName as character,
                                       input  poPrincipal as Principal,
                                       input  pcErrorString as character,
                                       input  poDomainCtx as JsonObject,
                                       output pcErrorCode as character,
                                       output pcErrorDetail as character,
                                       output poErrorURI as URI ).
    
end interface.