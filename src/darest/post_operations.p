/*************************************************************/
/* Copyright (c) 2014      by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_operations.p
    Purpose     : Post to the collection of operations. 
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2010
    Notes       :     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.

/* to be deprecated */
{darest/restbase.i post scripts} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.  

     
    /* ***************************  Definitions  ************************** */
    define variable policy       as IPartitionPolicy no-undo.
    define variable policySet    as IPartitionPolicySet no-undo.
   
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
    define variable cKey         as character no-undo.
    /* ***************************  Main Block  *************************** */
    
    service = new DataAdminService(restRequest:ConnectionName).
        
    restRequest:Validate().
    service:URL = restRequest:ConnectionUrl.
    cFile = restRequest:FileName.
    cFileOut = restRequest:OutFileName.
       
    if restRequest:KeyValue[1] = ? then 
        undo, throw new UnsupportedOperationError("POST operations with no key in URL:" + restRequest:RequestUrl).  
        
    case restRequest:KeyValue[1]:    
        
        when "PartitionPolicyDetailsFromData" then
        do:
            /* use collection to import non existing  policy (don't know the name) */
            policySet = service:NewPartitionPolicies().
            policySet:ImportTree(cFile).
            if policySet:Count > 1 then
                 undo, throw new IllegalArgumentError("The PartitionPolicyDetailsFromData request is for more than one policy.").
            if policySet:Count = 0 then
                 undo, throw new IllegalArgumentError("The PartitionPolicyDetailsFromData request has no policy data.").
            policy = cast(policySet:Iterator():Next(),IPartitionPolicy).
            policy:AddDetailsFromData().
            policy:Details:ExportTree(cFileOut).
        end. /* when tenant */
        otherwise 
             undo, throw new NotFoundError(restRequest:RequestUrl).  
    
    end case. 
    catch e as Progress.Lang.Error :
        if session:batch-mode then
            errorHandler =  new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).      
    end catch.
    finally:
        delete object service no-error.     
    end finally.
    
 
end.