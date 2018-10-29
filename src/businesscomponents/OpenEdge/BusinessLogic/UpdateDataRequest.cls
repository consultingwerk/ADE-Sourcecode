/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : UpdateDataRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-20
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.CommitScopeEnum.
using Ccs.BusinessLogic.IUpdateDataRequest.

class OpenEdge.BusinessLogic.UpdateDataRequest implements IUpdateDataRequest: 
    /* Returns the CommitScope to be used by the updateData method. The value is considered as a recommendation as 
       the Business Entity may ignore this setting and use a different commit scope based on the business logic 
       requirements */
    define public property CommitScope as CommitScopeEnum no-undo get. set. 
    
    /* Returns a custom request object */
    define public property CustomRequest as Progress.Lang.Object no-undo get. set. 

end class.