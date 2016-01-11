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
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IIndex from propath.
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
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Lang.*.

routine-level on error undo, throw.
class OpenEdge.DataAdmin.Binding.LocalIndexContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/localindex.i} 
    define buffer bLocalindex for ttLocalIndex.
    define temp-table copytable reference-only like ttLocalIndex.
       /* NOTE: needed for tracking changes*/ 
    define private dataset dsLocalindex serialize-name "root" for ttLocalIndex.
   
    define variable mCreate as logical no-undo.
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttLocalIndex:handle.
    	end get.
   
    define public override property KeyFields as character  no-undo  
        get():
            return "PartitionPolicyName,IndexName". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            if Count = ? then
            do:
                Count = 0.
                for each bLocalindex:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public LocalIndexContext ():
         super ("LocalIndex").                                    
    end constructor.
    
    constructor public LocalIndexContext (pscope as IContextScope):
         super ("LocalIndex",pScope).                                    
    end constructor.
    
 	method public override character GetJoinFields(parentid as char):
        if parentid = "PartitionPolicies" then 
             return "Name,PartitionPolicyName".
        return "".     
    end.
    
	method private void CopyTable(input table copytable):
	    define variable dataerror as DataContextError no-undo.      
	    define variable lTrack as logical no-undo.
        
        lTrack = temp-table ttLocalIndex:tracking-changes.
        
        for each copytable on error undo, throw:  
/*            if valid-object(Service) and valid-object(copytable.Entity) then*/
/*            do:                                                             */
/*                ValidateTenant(cast(copytable.Entity,ITenant)).             */
/*            end.                                                            */
            do on error undo, throw:
                 find bLocalIndex where copytable.PartitionPolicyName = bLocalIndex.PartitionPolicyName
                                    and  copytable.TableName = bLocalIndex.TableName  
                                    and  copytable.IndexName  = bLocalIndex.IndexName  
                                   no-error.
          /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bLocalIndex then
                do:
                    create bLocalIndex.
                    assign
                        bLocalIndex.PartitionPolicyName = copytable.PartitionPolicyName  
                        bLocalIndex.TableName = copytable.TableName  
                        bLocalIndex.IndexName = copytable.IndexName  .
                end.    
                catch e as Progress.Lang.Error :
                    delete bLocalIndex.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("LocalIndex",e).
                    else 
                       dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttLocalIndex:tracking-changes = true.
        for each copytable:
            create ttLocalIndex.    
            Count = Count + 1.
            buffer-copy copytable to ttLocalIndex.    
            OnRowCreated().
        end.
        temp-table ttLocalIndex:tracking-changes = ltrack.
            
    end method.  
	
    method public override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false. 
    end method. 
	
	method private character GetCreateError(idxField as IIndexField):
        return this-object:GetCreateError(cast(idxField,IDataAdminElement),idxField:Index:Name). 
    end method. 
	
	   /* override to add TableName not in foreign value   */
    method protected override void ReadRowForParent(pRow as IRow,json as JsonObject).
        define variable cTableName as character no-undo.
        define variable cSchemaname as character no-undo.
        if buffer ttLocalIndex:row-state = row-created then
        do:
            cTableName = pRow:FieldValue("TableName").
            cSchemaname = pRow:FieldValue("SchemaName").
            ttLocalIndex.TableName = cTableName.
            ttLocalIndex.SchemaName= cSchemaname.
            
        end.
        ReadRow(json,GetClientKeyFields()).
    end method. 
    
    method public override void InitRow(pname as char):
        undo, throw new UnsupportedOperationError("CreateRow with name in LocalIndexContext").
    end method.
    
    /* currently this will always throw error  */
	method public override void CreateRow(entity as IDataAdminElement):
        /* the default syserror has all info */
        CreateRow(cast(entity,IIndex)).    
    end method.
    
    method public void CreateRow(idx as IIndex):
        undo, throw new UnsupportedOperationError("Create Index in LocalIndexContext without specifying PartitionPolicy parent.").      
    end method.
       
    method public override void CreateRowForParent(pRow as IRow,pentity as IDataAdminElement):
        AssertNotNull(pEntity,"entity"). 
        if type-of(pentity,IIndex) then  
        do:
            CreateRowForParent(pRow,cast(pentity,IIndex)).
        end.    
        else 
            undo, throw new IllegalArgumentError("Cannot create " + pentity:getClass():TypeName +  " in PartitionPolicyField context.").    
    end.
    
    method public void CreateRowForParent(pRow as IRow,pIdx as IIndex):
        AssertNotNull(pIdx,"Index").
        CreateRow(pRow:KeyValue,pIdx:Schema:Name,pIdx:Table:Name,pIdx:Name). 
    end method.
    
	method public void CreateRow(ppolicyname as char, pSchemaname as char, ptablename as character, pindexName as character):
	    if ptablename = "" or ptablename = ? then 
            undo, throw new IllegalArgumentError("Table not specified").  
        if pindexName = "" or pindexName = ? then 
            undo, throw new IllegalArgumentError("Index not specified"). 
          
        define variable lTrack as logical no-undo.
        lTrack = temp-table ttLocalIndex:tracking-changes .
        temp-table ttLocalIndex:tracking-changes = true.
        
        Count = Count + 1.
         
        create ttLocalIndex.
        assign ttLocalIndex.Schemaname = pSchemaname
               ttLocalIndex.TableName = ptablename  
               ttLocalIndex.IndexName = pindexName  
               ttLocalIndex.PartitionPolicyName = ppolicyname.  
        
        OnRowCreated().      
        catch e as Error:  
            delete ttLocalIndex.
            Count = Count - 1.
            if type-of(e,IllegalArgumentError) then
                undo, throw e.
            undo, throw new DataContextError("TenantGroup and Tenant",e).  
        end catch.  
        finally:
            temp-table ttLocalIndex:tracking-changes = lTrack.             
        end finally.
                  
    end method.
    
   method public void UpdatePartitionPolicyName(pcOldname as char, pcNewname as char):
        define variable lTrack as logical no-undo.
        define buffer bLocalIndex for ttLocalIndex.
        lTrack = temp-table ttLocalIndex:tracking-changes.
        temp-table ttLocalIndex:tracking-changes = false.
        for each bLocalIndex where bLocalIndex.PartitionPolicyName = pcOldname:
            assign bLocalIndex.PartitionPolicyName = pcNewname.
        end.    
        finally:
            temp-table ttLocalIndex:tracking-changes = lTrack.
        end.
    end. 
    
    method public override logical CanFind(name as character):
        undo, throw new UnsupportedOperationError("CanFind with character key. LocalIndex Context has 3 componenet key.").           
    end.    
     
    method public logical CanFind(policyname as char, tableName as char,indexName as character ):
        return can-find(ttLocalIndex where ttLocalIndex.TableName = tableName
                                       and ttLocalIndex.IndexName = indexName
                                       and ttLocalIndex.PartitionPolicyName = policyname).
    end.    
    
    method public override logical Find(name as character):
        undo, throw new UnsupportedOperationError("Find with character key. LocalIndex Context has 3 componenet key.").           
    end.    
    
    method public logical Find(policyname as char, tableName as char,indexName as character ):
        find ttLocalIndex where ttLocalIndex.TableName = tableName
                            and ttLocalIndex.IndexName = indexName
                            and ttLocalIndex.PartitionPolicyName = policyname
                             no-error.       
        
        return avail ttLocalIndex.  
    end.    
    
    method public logical Delete(policyname as char, tableName as char,indexName as character ):
        define variable lTrack as logical no-undo.
        if this-object:Find(policyname,tableName,indexName) then  
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
