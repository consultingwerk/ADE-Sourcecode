/* ***********************************************************/
/* Copyright (c) 2011 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : runapi.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : egarcia
    Created     : Thu Mar 31 17:41:21 EDT 2011
    Notes       :
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using OpenEdge.DataAdmin.Rest.RestRequest from propath.
using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath.
using OpenEdge.DataAdmin.Error.OperationError from propath.

/* ***************************  Main Block  *************************** */

    define input parameter cPrm as character no-undo.
    
    define variable cSeparator        as character no-undo.
    define variable cProgramName      as character no-undo.
    define variable cConnectionString as character no-undo.
    define variable cURL              as character no-undo.
    define variable h                 as handle    no-undo.

    define variable restRequest       as RestRequest no-undo.
    define variable errorHandler      as DataAdminErrorHandler no-undo.
    
    cSeparator = substring(cPrm, 1, 1).
    if num-entries(cPrm, cSeparator) = 4 then
        assign cConnectionString = entry(2, cPrm, cSeparator)
               cProgramName      = entry(3, cPrm, cSeparator)           
               cURL              = entry(4, cPrm, cSeparator).
    else
        undo, throw new OperationError("Unexpected number of parameters in call to runapi").
    
    connect value(cConnectionString).
    run value(cProgramName) persistent set h.
    if valid-handle(h) then
    do:
        run executeRequest in h (cURL).
    end. 

    catch e as Progress.Lang.Error:
        restRequest = new RestRequest("run","runapi",cURL).
        if session:batch-mode then
            errorHandler = new DataAdminErrorHandler(restRequest:ErrorFileName).
        else
            errorHandler = new DataAdminErrorHandler().
        errorHandler:Error(e).
    end.
    finally :
    if valid-handle(h) then
	    delete object h.
        do while ldbname(1) <> ? :
            disconnect value(ldbname(1)).
        end.
    end.

