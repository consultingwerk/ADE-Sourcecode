 
 /*------------------------------------------------------------------------
    File        : CdcFieldPolicyPartitionQuery
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 26 17:14:38 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext.
using OpenEdge.DataAdmin.Binding.Query.IPartitionQuery.
using OpenEdge.DataAdmin.Binding.Query.PartitionQuery.
using OpenEdge.DataAdmin.Binding.TenantGroupContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.Query.CdcFieldPolicyPartitionQuery inherits PartitionQuery implements IPartitionContext, IPartitionQuery:
    
    define private variable PartitionContext as PartitionContext no-undo.
    define private variable mNew as logical no-undo.
    //define protected property DefaultAllocation as char get. set.
    define protected property DataArea as char get. set.
    define protected property IndexArea as char get. set.    
    define protected property TableName as char get. set. 
    
    define private property CdcFieldPolicyContext as CdcFieldPolicyContext no-undo
         get():
             return  cast(Model:GetChild("CdcFieldPolicies"),CdcFieldPolicyContext).
         end.
         
        constructor public CdcFieldPolicyPartitionQuery (pModel as PartitionContext, pParent as IRow,pReq as IRequestInfo):
        define variable lalloc as logical no-undo.
        super (pModel,pParent,pReq).     
        if pparent:Created then
        do:
            assign
                TableName         = pParent:FieldValue("TableName")
                /* detail IsAllocated true overrides or is same as policy default */
                //lAlloc            = logical(pParent:FieldValue("IsAllocated"))
                /* DefaultAllocation does nto exist in db, but is used to inherit parent default */
               //DefaultAllocation = pParent:FieldValue("DefaultAllocation")
                DataArea   = pParent:FieldValue("DataAreaName") 
                IndexArea  = pParent:FieldValue("IndexAreaName").
                
/*                message TableName */
/*                view-as alert-box.*/
            /* set to Immediate in case this is not the policy value 
               this is used to assign AllocationState to "allocated" on server for the 
               returned new partitions */
          /*  if lAlloc then
                DefaultAllocation = "Immediate".
            else if DefaultAllocation = "" then
                 DefaultAllocation = "None".*/
            if TableName = "" then
                undo, throw new IllegalOperationError("Request for partitions for new CdcFieldPolicy with no Table.").   
          
            mNew = true.
        end.
        PartitionContext = pModel.
    end constructor.
    
    method private char GetNewQuery():   
        return "for each ttpartition where ttPartition.TableName = " + quoter(TableName)                                 
                                  /*+ "  and ttCdcFieldPolicy.DataArea = "  + quoter(DataArea)
                                  + "  and ttCdcFieldPolicy.IndexArea = "  + quoter(IndexArea)*/.
    
    end method.
    
    method public override IFetchRequest GetQueryRequest():   
        if mNew then 
            return GetNewRequest().
        else 
            return super:GetQueryRequest().   
    end method.
    
    method public IFetchRequest GetNewRequest():   
        define variable msg as IFetchRequest no-undo.
        msg = new FetchRequest(Name,Id,DatasetHandle,yes).
        msg:SetTableRequestType("ttPartition","NEW").
        msg:SetTableQuery("ttPartition",GetNewQuery()).
        return msg.
    end method.
    
    method public override logical CanFind(pname as character):
        undo, throw new UnsupportedOperationError("CdcFieldPolicyPartitionQuery CanFind with single key").
    end.
    
    method public override logical Find(pname as character):
        undo, throw new UnsupportedOperationError("CdcFieldPolicyPartitionQuery Find with single key").
    end.

	method override public logical Allocate(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public logical CanFindField( input pctable as character, input pcfield as character ):
		return this-object:CanFind(pctable,pcfield,"",""). 
	end method.

	method override public logical CanFindGroup( input pcGroup as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollation as character ):
		 return false.
	end method.

	method public logical CanFindIndex( input pctable as character, input pcIndex as character, input pccollection as character ):
		return this-object:CanFind(pctable,"",pcIndex,pcCollection).
	end method.
	
	method protected logical CanFind(pctable as char,pcField as char, pcIndex as char, pccollection as char):
        if PartitionContext:FindFieldPolicy(ParentValue,pctable,pcField,pcIndex,pcCollection) then
            return CanFindCurrentModel(PartitionContext).
    end method.
    /*
	method public override logical CanFindFieldPolicy(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        if ParentValue = pcFPolicy then
        do: 
            if PartitionContext:FindFieldPolicy(ParentValue,pctable,pcField,pcIndex,pcCollection) then
                return CanFindCurrentModel(PartitionContext).
        end. 
        return false.  
    end method. */

	method public logical CanFindTable( input pctable as character ):
		return this-object:CanFind(pctable,"","",""). 
	end method.

	method override public logical CanFindTenant( input pcTenant as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollation as character ):
		 return false.
	end method.

	method override public logical FindField( input pctable as character, input pcField as character ):
		return this-object:Find(pctable,pcfield,"",""). 
	end method.

	method override public logical FindGroup( input pcGroup as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollation as character ):
		return false.
	end method.

	method override public logical FindIndex( input pctable as character, input pcIndex as character, input pcCollection as character ):
		return this-object:Find(pctable,"",pcIndex,pcCollection).
	end method.
	
	method protected logical Find(pctable as char,pcField as char, pcIndex as char,pccollation as char):
        if PartitionContext:FindFieldPolicy(ParentValue,pctable,pcField,pcIndex,pccollation) then
           return SynchWithModel(PartitionContext).
        return false.    
    end method.
/*
	method override public logical FindFieldPolicy( input pcFPolicy as character, input pctable as character, input pcField as character, input pcIndex as character, input pcCollection as character ):
		if ParentValue = pcFPolicy then
        do: 
            if PartitionContext:FindFieldPolicy(ParentValue,pctable,pcField,pcIndex,pcCollection) then
                return SynchWithModel(PartitionContext).
        end. 
        return false.
	end method.*/

	method override public logical FindTable( input pctable as character ):
		return this-object:Find(pctable,"","",""). 
	end method.

	method override public logical FindTenant( input pcTenant as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollation as character ):
		return false.
	end method.
	
	method public override logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.  
    end method.
    
    method public override logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.  
    end method. 

end class.