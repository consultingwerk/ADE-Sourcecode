/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Thrown when an operation is not supported on a network client.
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 11/11/2014
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw. 
using Progress.Lang.* from propath.
using Progress.Lang.AppError from propath.
using OpenEdge.DataAdmin.Error.DataAdminError.


class OpenEdge.DataAdmin.Error.NetworkClientOperationError inherits DataAdminError: 
    
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    constructor public NetworkClientOperationError (msg as char, e as Error ):
        super ((if msg <> "" then msg else "The operation") + " is not supported when connected to the database as a network client (-S).",e).
        HTTPErrorNum = 501. /*501 not implemented */       
    end constructor.
    
	constructor public NetworkClientOperationError (msg as char ):
	    this-object(msg,?).   
	end constructor.
   
    constructor public NetworkClientOperationError (  ):
        this-object("").
    end constructor.
end class.
