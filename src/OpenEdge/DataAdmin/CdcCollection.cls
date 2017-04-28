 
 /*------------------------------------------------------------------------
    File        : CdcCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Nov 30 16:49:29 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.DataAdminCollection from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.ICdcCollection from propath.
using OpenEdge.DataAdmin.ICdc from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Cdc from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.IField from propath.
using OpenEdge.DataAdmin.IIndex from propath.
  
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.ICdcContext from propath.
//using OpenEdge.DataAdmin.Binding.CdcContext from propath. 
using OpenEdge.DataAdmin.Binding.QueryContext from propath.
class OpenEdge.DataAdmin.CdcCollection inherits DataAdminCollection implements ICdcCollection: 
    
     define private variable mLoaded   as logical no-undo.
     
     define protected property CdcContext as ICdcContext no-undo 
       get():
           return cast(Context,ICdcContext). 
       end.
       
   /* constructor CdcCollection(cntxt as CdcContext):
        super(cntxt).  
    end constructor.*/
    
    constructor CdcCollection(cntxt as IDataAdminContext):
        super(cntxt).  
    end constructor. 
    
    constructor CdcCollection(cntxt as QueryContext):
        super(cntxt).  
    end constructor. 
    
    constructor CdcCollection(cntxt as FilteredContext):
        super(cntxt).  
    end constructor. 
    
    method protected override IDataAdminContext CreateLocalContext():
       // return new CdcContext().
    end.

	method public logical CanFindGroup( input pcGroup as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollection as character ):
		return CdcContext:CanFindGroup(pcGroup,pctable,pcField,pcIndex,pcCollection).
	end method.

	method public logical CanFindTenant( input pcTenant as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollection as character ):
		return CdcContext:CanFindTenant(pcTenant,pctable,pcField,pcIndex,pcCollection). 
	end method.	
	
	method public ICdc FindFieldPolicy(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char,pccollection as char):
         //return cast(CdcContext:FindFieldPolicyEntity(pcFPolicy,pctable,pcField,pcIndex,pcCollection),IPartition). 
    end method.    
   
    method public logical CanFindFieldPolicy(pcFPolicy as char,pctable as char,pcField as char, pcIndex as char,pccollection as char).
        return CdcContext:CanFindFieldPolicy(pcFPolicy,pctable,pcField,pcIndex,pcCollection). 
    end method. 

	method public logical Contains( input cdc as ICdc ):
		define variable cName as character no-undo.
        define variable cTableName as character no-undo.
        define variable cFieldName as character no-undo.
        define variable cIndexName as character no-undo.
        define variable cCollation as character no-undo.
        
        if cdc:ContextId <> ContextId then 
            return false. 
            
        if type-of(cdc:element,ITable) then                                                                                       
        do:
            cTableName = cdc:element:Name.           
        end.
        else if type-of(cdc:element,IIndex) then
        do: 
            assign
                cTableName = cast(cdc:element,IIndex):Table:Name           
                cIndexName = cdc:element:Name
                cCollation = "". 
        end.
        else if type-of(cdc:element,IField) then
        do:
            assign
                cTableName = cast(cdc:element,IField):Table:Name           
                cFieldName = cdc:element:Name.
        end.        
        //if valid-object(cdc:tTenant) then       
         //   return CanFindTenant(cdc:Tenant:Name,ctablename,cFieldname, cIndexName,ccollation).
       // else          
            return CanFindGroup(cdc:TenantGroup:Name,ctablename,cFieldname, cIndexName,ccollation).
	end method.	

	method public OpenEdge.DataAdmin.ICdc FindGroup( input pcgroup as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollection as character ):
		// return cast(CdcContext:FindGroupEntity(pcGroup,pctable,pcField,pcIndex,pcCollection),IPartition). 
	end method.
	
	 method public override logical Contains(obj as Object):
        return Contains(cast(obj,ICdc)).   
        catch e as Progress.Lang.Error :
            return false.   
        end catch.
    end method.

	method public ICdc FindTenant( input pcTenant as character, input pctable as character, input pcField as character, input pcIndex as character, input pccollection as character ):
		// return cast(CdcContext:FindTenantEntity(pcTenant,pctable,pcField,pcIndex,pcCollection),IPartition). 
	end method.

	method override protected void PrepareExport(  ):
		
	end method.

	method override protected void PrepareExportList(  ):
	end method.

	method override protected void PrepareExportTree(  ):
	end method.
	
end class.