/*************************************************************/
USING OpenEdge.DataAdmin.Binding.IDataAdminModel.
USING OpenEdge.DataAdmin.Entity.
USING OpenEdge.DataAdmin.IRequestInfo.
USING OpenEdge.DataAdmin.ITable.
USING OpenEdge.DataAdmin.IUser.
USING OpenEdge.DataAdmin.IUserFieldPermission.
USING Progress.Lang.*.
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : UserFieldPermission
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
  
class OpenEdge.DataAdmin.UserFieldPermission inherits Entity implements IUserFieldPermission: 
	
    define public property CanRead as logical no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanRead.
            else
                return CanRead. 
        end.
    
    define public property CanWrite as logical no-undo     
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanWrite.
            else
                return CanWrite. 
        end.
	
	constructor public UserFieldPermission ( cntxt as IDataAdminModel ):
        super (cntxt).
    end constructor.
    
    constructor public UserFieldPermission ( cntxt as IDataAdminModel,preq as IRequestInfo ):
        super (cntxt,pReq).
    end constructor.
    
    /* No local context needed - no child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
     
end class.
