/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : IllegalArgumentError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.
 
using OpenEdge.DataAdmin.Error.DataAdminError.

class OpenEdge.DataAdmin.Error.IllegalArgumentError inherits DataAdminError: 
    constructor public IllegalArgumentError (pmsg as char):  
        super("Illegal argument: " + pmsg).
    end method. 
    
    constructor public IllegalArgumentError (pmsg as char, e as Error):  
        super("Illegal argument: " + pmsg,e).
    end method. 
    
        
end class.
