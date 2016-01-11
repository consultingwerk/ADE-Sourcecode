/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : tablesforhp is a named query collection for tables that are ready/able to be 
                  horizontally partitioned, but does not have a policy yet 
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     :  
    Notes       : Uses the get-tables as super 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.DataAdmin.Rest.IRestRequest from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
define variable hSuper as handle no-undo.
 
if session:batch-mode and not this-procedure:persistent then 
do:
    undo, throw new AppError (target-procedure:file-name + " can only be run persistent",?).
end.

run darest/get_tables.p persistent set hSuper.
this-procedure:add-super-procedure (hSuper,search-target). 

procedure Execute:
    define input parameter restRequest as IRestRequest  no-undo.   
    if restRequest:KeyValue[1] > "" then 
    do:
        undo, throw new UnsupportedOperationError("URL with key for tablesforhp.").
    end.
    run super(restRequest).    
end.

    
