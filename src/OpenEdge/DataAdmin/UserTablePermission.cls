/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : UserTablePermission
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ISchema.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.IUserFieldPermissionSet.
using OpenEdge.DataAdmin.IUserTablePermission.
using OpenEdge.DataAdmin.UserTablePermission.
using Progress.Lang.*.

class OpenEdge.DataAdmin.UserTablePermission final inherits Entity  implements IUserTablePermission: 
           
    define public property Hidden as logical no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Hidden.
            else
                return Hidden. 
        end.
        
    define public property Frozen as logical no-undo   
        get():
            if valid-handle(mBuffer) then
                return mBuffer::Frozen.
            else
                return Frozen. 
        end.
        
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
    
    define public property CanCreate as logical no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanCreate.
            else
                return CanCreate. 
        end.
    
    define public property CanDelete as logical no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanDelete.
            else
                return CanDelete. 
        end.
    
    define public property CanLoad as logical no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanLoad.
            else
                return CanLoad. 
        end.
    
    define public property CanDump as logical no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanDump.
            else
                return CanDump. 
        end.
    
    /* lists all LOBs in the schema */ 
    define public property UserFieldPermissions as IUserFieldPermissionSet no-undo     
        get():
            if valid-handle(mBuffer) and not valid-object(UserFieldPermissions) then
            do:
                UserFieldPermissions = cast(GetChildCollection("userFieldPermissions"),IUserFieldPermissionSet).         
            end.
            return UserFieldPermissions.
        end.
        protected set.
       
    method public override void Export():
        export("tablepermission.json").
    end method.          
    
   /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public UserTablePermission ( cntxt as IDataAdminModel ):
		super (cntxt).
	end constructor.
	
    constructor public UserTablePermission ( cntxt as IDataAdminModel , preq as IRequestInfo):
        super (cntxt,preq).
    end constructor.
    
    /* No local context needed - no child collections   */ 
    method protected  override IDataAdminModel CreateLocalContext():
        return ?.
    end method.
    
    method public override void Export(cFile as char):
        define variable htbl as handle no-undo.
        if not valid-handle(mDefaultBuffer) then
        do:
            undo, throw new UnsupportedOperationError("Export of new table").
        end.
        create temp-table htbl.
        htbl:create-like(mDefaultBuffer).
        htbl:temp-table-prepare ("ttTablePermission").
        htbl:default-buffer-handle:buffer-copy (mBuffer).
        htbl:default-buffer-handle:serialize-name = "tablePermissions".     
        htbl:default-buffer-handle:write-json ("File",cFile,yes).   
    end method.
    
    
 end class.