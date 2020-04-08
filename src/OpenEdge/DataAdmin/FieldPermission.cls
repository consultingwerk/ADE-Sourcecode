/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Default implementation of IFieldPermission 
                  Mapped to a subset of _Field.   
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.IFieldPermission.
using OpenEdge.DataAdmin.IRequestInfo.
using Progress.Lang.*.
class OpenEdge.DataAdmin.FieldPermission inherits Entity implements IFieldPermission: 
	    
    define public property CanRead as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanRead.
            else
                return CanRead. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanRead = pVal.
            end.
            CanRead = pVal.
        end.    
    
    define public property CanWrite as character no-undo     
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanWrite.
            else
                return CanWrite. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanWrite = pVal.
            end.
            CanWrite = pVal.
        end.    
	
	constructor public FieldPermission ( cntxt as IDataAdminModel ):
        super (cntxt).
    end constructor.
    
    constructor public FieldPermission ( cntxt as IDataAdminModel ,pReq as IRequestInfo ):
        super (cntxt,pReq).
    end constructor.
    
    /* No local context needed - no child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
     
     
end class.
