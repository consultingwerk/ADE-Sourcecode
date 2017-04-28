/*************************************************************/
/* Copyright (c) 2016 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : get_tablesforcdc.p
    Purpose     : tablesforcdc is a named query collection for tables that are ready for Change Data Capture 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Tue May 24 12:58:40 IST 2016
    Notes       :
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
            undo, throw new UnsupportedOperationError("URL with key for tablesforcdc.").
        end.
        run super(restRequest).    
    end.

    
