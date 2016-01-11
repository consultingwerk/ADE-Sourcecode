/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Wraps info about a row key change for interobject messages/events
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Oct 08 15:09:48 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRowChange.
using OpenEdge.DataAdmin.Binding.RowImpl.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.RowChange inherits RowImpl implements IRowChange: 
    define public property OldKeyValues as character extent no-undo 
       get.
       private set. 

    constructor public RowChange (pContext as IDataAdminModel, pSerializename as char,pKeyFields as char,pOldKeyValues as char extent,pNewFieldValues as char extent):
        super (pContext,pSerializename,row-modified,pKeyFields,pNewFieldValues).
        OldKeyValues = pOldKeyValues.
    end constructor.    

end class.