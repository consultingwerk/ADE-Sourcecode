/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_sequences.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.ISequenceSet from propath.
using OpenEdge.DataAdmin.ISequence    from propath.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
 
 
 /* old behavior - to be deprecated */
{darest/restbase.i get sequences}  

procedure Execute:
    define input  parameter restRequest as IRestRequest  no-undo.          
    /* ***************************  Definitions  ************************** */
   
    define variable sequences    as ISequenceSet no-undo.
    define variable seq          as ISequence    no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest:Validate().
    service = new DataAdminService(restRequest:ConnectionName).
   
    service:URL = restRequest:ConnectionUrl.
    
    if restRequest:KeyValue[1] > "" then 
    do:
        seq = service:GetSequence(restRequest:KeyValue[1]).
        if not valid-object(seq) then
            undo, throw new NotFoundError("Sequence '"  + restRequest:KeyValue[1]  + "' not found").
         
        seq:Export(restRequest:OutFileName).
    end.    
    else do:
        pageRequest = restRequest:GetPageRequest().
        if valid-object(pageRequest) then 
            sequences = service:GetSequences(pageRequest).
        else
        if restRequest:Query > "" then 
            sequences = service:GetSequences(restRequest:Query).
        else 
            sequences = service:GetSequences().
        sequences:Export(restRequest:OutFileName).    
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