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
using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.
using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
 
define variable mMode       as char init "get" no-undo.
define variable mCollection as char init "sequences" no-undo.

if session:batch-mode and not this-procedure:persistent then 
do:
   output to value("get_sequences.log"). 
   run executeRequest(session:parameter).  
end.
finally:
    if session:batch-mode then output close.            
end finally.  
 
procedure executeRequest:
    define input  parameter pcParam as character no-undo.      
    /* ***************************  Definitions  ************************** */
   
    define variable sequences    as ISequenceSet no-undo.
    define variable seq          as ISequence    no-undo.
    define variable restRequest  as RestRequest no-undo.
    define variable pageRequest  as IPageRequest no-undo.
    define variable service      as DataAdminService no-undo.
    define variable errorHandler as DataAdminErrorHandler no-undo.
    /* ***************************  Main Block  *************************** */
    
    restRequest = new RestRequest(mMode,mCollection,pcParam).  
    
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