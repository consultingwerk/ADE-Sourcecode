/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_partitionpolicies.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Jun 19 15:53:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*  from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.IPartitionPolicySet from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.RequestInfo from propath.

using OpenEdge.DataAdmin.Rest.IRestRequest from propath.

using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
 
 
 /* old behavior - to be deprecated */
{darest/restbase.i get partitionpolicies}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.   
    /* ***************************  Definitions  ************************** */
    define variable PartitionPolicy  as IPartitionPolicy no-undo.
    define variable detail           as IPartitionPolicyDetail no-undo.
  
    define variable PartitionPolicies as IPartitionPolicySet no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable policyreq    as IRequestInfo no-undo.
    define variable valuereq     as IRequestInfo no-undo.
 
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    
    /* ***************************  Main Block  *************************** */
     
    service = new DataAdminService(restRequest:ConnectionName). 
    service:URL = restRequest:ConnectionUrl.
    if restRequest:KeyValue[1] > "" then
    do:
        
        policyreq = new RequestInfo("Name",restRequest:KeyValue[1]).
        if restRequest:NumLevels = 2 and restRequest:CollectionName[2] > "" and restRequest:KeyValue[2] = ? then
        do:
            pageRequest = restRequest:GetPageRequest().
            if valid-object(pageRequest) then
               policyreq:Add(pageRequest).
            else if restRequest:Query > "" then
            do:
                valuereq = new RequestInfo(restRequest:CollectionName[2]).
                valueReq:QueryString = restRequest:Query.
                policyreq:Add(valueReq).
            end.
        end.    
        PartitionPolicy = service:GetPartitionPolicy(policyreq).
        
        if PartitionPolicy = ? then
             undo, throw new NotFoundError("Partition Policy "  + quoter(restRequest:KeyValue[1])  + " not found").
        if restRequest:NumLevels > 1 then
        do:
            if restRequest:NumLevels = 2 then
            do: 
                if restRequest:CollectionName[2] = "PartitionPolicyDetails" then
                do:
                    if restRequest:KeyValue[2] > "" then
                    do:
                        detail = PartitionPolicy:Details:Find(restRequest:KeyValue[2]).
                        if not valid-object(detail) then
                            undo, throw new NotFoundError("Partition Policy Detail "  + quoter(restRequest:KeyValue[2])  + " not found for Partition Policy " + quoter(restRequest:KeyValue[1])).
                      
                        detail:ExportTree(restRequest:OutFileName).
                    end.
                    else
                        PartitionPolicy:Details:ExportTree(restRequest:OutFileName).
                end. 
                else    
                    undo, throw new NotFoundError ("Unknown URL: " + restRequest:RequestURL).
            end.
            else
                undo, throw new NotFoundError ("Unknown URL: " + restRequest:RequestURL).
        end.
        else /* policy details needs batching and are retrieved separately */
            PartitionPolicy:ExportTree(restRequest:OutFileName,'PartitionPolicyFields,LocalIndexes').
    end.
    else do:
        pageRequest = restRequest:GetPageRequest().
        define variable i1 as integer no-undo.
        define variable i2 as integer no-undo.
        i1 = etime(true).
        if valid-object(pageRequest) then 
            PartitionPolicies = service:GetPartitionPolicies(pageRequest).
        else if restRequest:Query > "" then
            PartitionPolicies = service:GetPartitionPolicies(restRequest:Query).
        else
            PartitionPolicies = service:GetPartitionPolicies().
        PartitionPolicies:ExportTree(restRequest:OutFileName,"PartitionPolicyFields").
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
    
 end procedure.
   
