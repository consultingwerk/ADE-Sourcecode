 /*************************************************************/
 /* Copyright (c) 2013 by progress Software Corporation       */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2013
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IIndexField.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IndexField.
using OpenEdge.DataAdmin.IndexFieldList.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.SaveRequest.
using OpenEdge.DataAdmin.Support.TenantGroupTenantGroupMemberSet.
using OpenEdge.DataAdmin.Support.TenantTenantGroupMemberSet.
using Progress.Lang.*.
 
class OpenEdge.DataAdmin.Binding.IndexFieldContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/indexfield.i} 
    define buffer bIndexField for ttIndexField.
    define temp-table copytable reference-only like ttIndexField.
      
    define variable mCreate as logical no-undo.
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttIndexField:handle.
    	end get.
   
    define public override property KeyFields as character  no-undo  
        get():
            return "TableName,IndexName,FieldName". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            if Count = ? then
            do:
                Count = 0.
                for each bIndexField:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public IndexFieldContext ():
         super ("IndexField").                                    
    end constructor.
    
    constructor public IndexFieldContext (pscope as IContextScope):
         super ("IndexField",pScope).                                    
    end constructor.
 	
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity,IIndexField)).    
	end method.
	
    method public override character GetJoinFields(parentid as char):
        case parentid: 
            when "indexes" then          
                return "TableName,TableName,Name,IndexName".
            when "fields" then          
                return "TableName,TableName,Name,FieldName".
        end.
    end.
    
    method public override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false. 
    end method. 
   
    method public void ReplaceTable(cntxt as IDataAdminContext):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        ReplaceTable(table-handle hTbl by-reference). 
        Loaded = false. 
    end method. 
   
    method private void ReplaceTable(input table copytable):
        define variable dataerror as DataContextError no-undo.      
       
        temp-table ttIndexField:tracking-changes = true.
        for each bIndexField on error undo, throw: 
            find copytable where copytable.TableName = bIndexField.TableName
                            and  copytable.IndexName  = bIndexField.IndexName  
                            and  copytable.FieldName  = bIndexField.FieldName  
                            no-error.
            if not avail copytable then
            do:              
               delete bIndexField.
               Count = Count - 1. 
            end.
        end.     
        for each copytable on error undo, throw:  
            find bIndexField where copytable.TableName = bIndexField.TableName
                              and  copytable.IndexName  = bIndexField.IndexName  
                              and  copytable.FieldName  = bIndexField.FieldName  
                            no-error.
           /* force error message 
               - DataError will transform progress message 
                 to "entity" message */
            if not avail bIndexField then
            do:
                create bIndexField.
                assign
                    bIndexField.TableName = copytable.TableName  
                    bIndexField.IndexName = copytable.IndexName  
                    bIndexField.FieldName = copytable.FieldName.  
                
                Count = Count + 1.
                OnRowCreated().
            end.   
             
            catch e as Progress.Lang.Error :
                delete bIndexField.
                if not valid-object(DataError) then 
                    dataError = new DataContextError("TenantGroup",e).
                else 
                   dataError:AddMessage(e).                     
            end catch. 
        end.    
        temp-table ttIndexField:tracking-changes = false.                     
    end method.  
    
	method private void CopyTable(input table copytable):
	    define variable dataerror as DataContextError no-undo.      
        for each copytable on error undo, throw:  
/*            if valid-object(Service) and valid-object(copytable.Entity) then*/
/*            do:                                                             */
/*                ValidateTenant(cast(copytable.Entity,ITenant)).             */
/*            end.                                                            */
            do on error undo, throw:
                 find bIndexField where copytable.TableName = bIndexField.TableName
                            and  copytable.IndexName  = bIndexField.IndexName  
                            and  copytable.FieldName  = bIndexField.FieldName  
                            no-error.
          /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bIndexField then
                do:
                    create bIndexField.
                    assign
                        bIndexField.TableName = copytable.TableName  
                        bIndexField.IndexName = copytable.IndexName  
                        bIndexField.FieldName = copytable.FieldName.  
                    
                end.    
                catch e as Progress.Lang.Error :
                    delete bIndexField.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("PartititonGroup",e).
                    else 
                       dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttIndexField:tracking-changes = true.
        for each copytable:
            create ttIndexField.    
            Count = Count + 1.
            buffer-copy copytable to ttIndexField.    
            OnRowCreated().
        end.
        temp-table ttIndexField:tracking-changes = false.
            
    end method.  
	
	method private character GetCreateError(idxField as IIndexField):
        return this-object:GetCreateError(cast(idxField,IDataAdminElement),idxField:Index:Name). 
    end method. 
	
	method public void CreateRow(tablename as character, indexName as character,fieldname as char):
	    if tablename = "" or tablename = ? then 
            undo, throw new IllegalArgumentError("Table not specified").  
        if indexName = "" or indexName = ? then 
            undo, throw new IllegalArgumentError("Index not specified"). 
        if fieldname = "" or fieldname = ? then 
            undo, throw new IllegalArgumentError("Field not specified").  
        
         CreateRow(tablename,indexName,fieldname,?).
    end method.
         
    method private void CreateRow(tablename as character, indexName as character,fieldname as char,idxfld as IIndexField):
        define variable lTrack as logical no-undo.
        lTrack = temp-table ttIndexField:tracking-changes .
        temp-table ttIndexField:tracking-changes = true.
        
        Count = Count + 1.
         
        create ttIndexField.
        assign ttIndexField.TableName = tablename
               ttIndexField.IndexName = indexName  
               ttIndexField.FieldName = fieldname   
               ttIndexField.Number = Count   
               
               ttIndexField.Entity = idxfld .
        
        OnRowCreated().      
        catch e as Error:  
            delete ttIndexField.
            Count = Count - 1.
            if type-of(e,IllegalArgumentError) then
                undo, throw e.
            undo, throw new DataContextError("TenantGroup and Tenant",e).  
        end catch.  
        finally:
            temp-table ttIndexField:tracking-changes = lTrack.             
        end finally.
                  
    end method.
	
	method public void CreateRow(idxfld as IIndexField ):
	     
	    
/*	    if valid-object(Service) then*/
/*	       ValidateTenant(tenant).   */
/*	                                  */
/*         if not valid-object(tenantGroupDetail:TenantGroup) then*/
/*            undo, throw new IllegalArgumentError(               */
/*            GetCreateError(tenantGroupDetail)                   */
/*            + "~nTenantGroup not defined ").                    */
/*                                                                */
/*         if not valid-object(tenantGroupDetail:Tenant) then     */
/*            undo, throw new IllegalArgumentError(               */
/*            GetCreateError(tenantGroupDetail)                   */
/*            + "~nTenant not defined ").                         */
             
        CreateRow(idxfld:Index:Table:Name,idxfld:Index:Name,idxfld:Field:Name,idxfld).
             
    end method.
    
    method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind with character key. IndexField Context has 3 componenet key.").           
    end.    
     
    method public logical CanFind(tableName as char,indexName as character, fieldName as character):
        return can-find(ttIndexField where ttIndexField.TableName = tableName
                                      and ttIndexField.IndexName = indexName
                                      and ttIndexField.FieldName = fieldName).
    end.    
    
    method public logical CanFind(tableName as char,indexName as character,number as int):
        return can-find(ttIndexField where ttIndexField.TableName = tableName
                                      and ttIndexField.IndexName = indexName
                                       and ttIndexField.Number = number).
    end.   
    
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find with character key. IndexField Context has 3 componenet key.").           
    end.    
    
    method public logical Find(tableName as char,indexName as character, fieldName as character):
        find ttIndexField where ttIndexField.TableName = tableName
                            and ttIndexField.IndexName = indexName
                            and ttIndexField.FieldName = fieldName
                             no-error.       
        
        return avail ttIndexField.  
    end.    
    
    method public logical Find(tableName as char,indexName as character, number as int):
        find ttIndexField where ttIndexField.TableName = tableName
                            and ttIndexField.IndexName = indexName
                            and ttIndexField.Number = number
                             no-error.       
        
        return avail ttIndexField.  
    end.    
    
    method public logical Delete(tableName as char,indexName as character, number as int):
        define variable lTrack as logical no-undo.
        if this-object:Find(tableName,indexName,number) then  
        do:
            return Remove().
        end. 
/*        else                                                                                         */
/*            undo, throw new DataContextError('Delete failed. Cannot find Partition Group Detail for '*/
/*                                            + 'Tenant ' + quoter(detail:TenantGroup:Name)         */
/*                                            + 'Partition Group ' + quoter(detail:Tenant:Name) ).     */
/*                                                                                                     */
        
        return false.
    end.
    
    method public logical Delete(tableName as char,indexName as character, fieldName as character):
        define variable lTrack as logical no-undo.
        if this-object:Find(tableName,indexName,fieldName) then  
        do:
            return Remove().
        end. 
/*        else                                                                                         */
/*            undo, throw new DataContextError('Delete failed. Cannot find Partition Group Detail for '*/
/*                                            + 'Tenant ' + quoter(detail:TenantGroup:Name)         */
/*                                            + 'Partition Group ' + quoter(detail:Tenant:Name) ).     */
/*                                                                                                     */
        
        return false.
    end.    
      
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):        
        undo, throw new UnsupportedOperationError("CreateCollection with context only (no key).").           
     end method.
    
    method protected override IDataAdminElement CreateEntity( preq as IRequestInfo):
        return new IndexField (this-object,preq).
    end method.
   
    method override protected IDataAdminCollection CreateCollection(pparent as char,cntxt as FilteredContext):     
        case pparent:
            when "indexes" then
            do:
                return new IndexFieldList(cntxt) .
            end.                 
            when "fields" then
            do:
               undo, throw new UnsupportedOperationError("CreateCollection for fields not implemented.").           
               /*                return new   FieldIndexFieldSet(cntxt) .*/
            end.                 
            otherwise
                return super:CreateCollection(pparent,cntxt).        
        end case.    
        
    end method.
    
    method protected override handle CreateSaveDataset():
        return CreateDataset("tenantGroupMembers").       
    end method.
    
    method protected override char FindExpression(i as int):
        undo, throw new UnsupportedOperationError("FindExpression with integer key").  
    end method.
    
    method protected override char FindExpression(c as char):
        undo, throw new UnsupportedOperationError("FindExpression with character key").  
    end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
    
/*      /** DataRefreshed Override to handle requests for indexfields  */                               */
/*    method public override void DataRefreshed(pResponse as OpenEdge.DataAdmin.Message.IFetchResponse):*/
/*        define variable i as integer no-undo.                                                         */
/*        super:DataRefreshed(pResponse).                                                               */
/*        define variable cc as character no-undo.                                                      */
/*        for each ttindexfield:                                                                        */
/*           cc = cc                                                                                    */
/*           +  " tbl " + ttindexfield.TableName                                                        */
/*             +  " fld "  + ttindexfield.FieldName   +  " idx "  + ttindexfield.IndexName              */
/*             + chr(10).                                                                               */
/*                                                                                                      */
/*        end.                                                                                          */
/*        message cc                                                                                    */
/*        view-as alert-box.                                                                            */
/*    end method.                                                                                       */
/*                                                                                                      */
    
 
end class.
