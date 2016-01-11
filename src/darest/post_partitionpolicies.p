/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : post_partitionpolicies.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 2013
    Notes       :     
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.*.
using OpenEdge.DataAdmin.Rest.*.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.Lang.Collections.IIterator from propath.

/* to be deprecated */
{darest/restbase.i post partitionpolicies} 
  
procedure Execute :
    define input parameter restRequest as IRestRequest  no-undo.  

 
    /* ***************************  Definitions  ************************** */
    define variable policies     as IPartitionPolicySet no-undo.    
    define variable policy       as IPartitionPolicy no-undo.    
    define variable iter         as IIterator no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    define variable cFile        as character no-undo.
    define variable cFileOut     as character no-undo.
   
    define variable cLong as longchar no-undo.
     
    /* ***************************  Main Block  *************************** */
    service = new DataAdminService(restRequest:ConnectionName).
    restRequest:Validate().
    
    service:URL = restRequest:ConnectionUrl.
    
    assign
        cFile = restRequest:FileName
        cFileOut = restRequest:OutFileName.
       
    If restRequest:KeyValue[1] > "" then
    do: 
        if restRequest:NumLevels = 1 then 
            undo, throw new UnsupportedOperationError("Cannot pass key in url for POST: " + restRequest:RequestUrl).  
        
        if restRequest:CollectionName[2] = "partitionpolicydetails" then
        do:
            policy = service:GetPartitionPolicy(restRequest:KeyValue[1]).
            if not valid-object(policy) then
                undo, throw new NotFoundError("Partition Policy "  + restRequest:KeyValue[1]  + " not found").
            policy:Details:ImportNewTree(cFile).
            service:UpdatePartitionPolicy(policy) .
            policy:Details:ExportLastSavedTree(cFileOut) .  
          
        end.  
        else
            undo, throw new NotFoundError("URL not found: " + restRequest:RequestUrl).  
    end.
    else do:
        policies = service:NewPartitionPolicies().
        policies:ImportNewTree(cFile).  
        iter =  policies:Iterator().
        do while iter:HasNext() :
            policy = cast(iter:Next(),IPartitionPolicy).
            if policy:Details:Count = 0 then
            do:
                policy:AddDetailsFromData().
            end.    
        end.    
        service:CreatePartitionPolicies(policies).
        policies:ExportLastSavedTree(cFileOut).
    end.
 
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