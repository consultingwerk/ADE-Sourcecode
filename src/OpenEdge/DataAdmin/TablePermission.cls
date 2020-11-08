/*************************************************************/
/* Copyright (c) 2011,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : TablePermission
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
using OpenEdge.DataAdmin.IFieldPermissionSet.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ISchema.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.ITablePermission.
using OpenEdge.DataAdmin.TablePermission.
using Progress.Lang.*.
class OpenEdge.DataAdmin.TablePermission final inherits Entity  implements ITablePermission: 
    define public property Schema as ISchema no-undo 
        get():
            if valid-object(Service) then
                return Service:GetSchema().
            return this-object:Schema.
        end.    
        
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
    
     define public property IsMultiTenant as logical no-undo  
         get():
             if valid-handle(mBuffer) then
                 return mBuffer::IsMultiTenant.
             return IsMultiTenant.
         end.    
        
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
        
    define public property CanCreate as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanCreate.
            else
                return CanCreate. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanCreate = pVal.
            end.
            CanCreate = pVal.
        end.    
        
    define public property CanDelete as character no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanDelete.
            else
                return CanDelete. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanDelete = pVal.
            end.
            CanDelete = pVal.
        end.    
    
    define public property CanLoad as character no-undo 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanLoad.
            else
                return CanLoad. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanLoad = pVal.
            end.
            CanLoad = pVal.
        end.    
        
    define public property CanDump as character no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::CanDump.
            else
                return CanDump. 
        end.
        set(pVal as char):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::CanDump = pVal.
            end.
            CanDump = pVal.
        end.    
     
    define public property FieldPermissions as IFieldPermissionSet no-undo     
        get():
             if not valid-object(FieldPermissions) then
                FieldPermissions = cast(GetChildCollection("fieldPermissions"),IFieldPermissionSet).
   
             return FieldPermissions.
        end.
        protected set.
        
    method public override void Export():
        export("tablepermission.json").
    end method.          
    
   /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public TablePermission ( cntxt as IDataAdminModel ):
		super (cntxt).
	end constructor.
        
    constructor public TablePermission ( cntxt as IDataAdminModel ,pReq as IRequestInfo):
        super (cntxt,pReq).
    end constructor.
    
    /* No local context needed - not used locally   */ 
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