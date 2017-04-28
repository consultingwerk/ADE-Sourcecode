 /* ***********************************************************/
/* Copyright (c) 2015-2017 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

 /*------------------------------------------------------------------------
    File        : CdcTablePolicy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Nov 20 15:02:39 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.AbstractPartitionParent.
using OpenEdge.DataAdmin.ICdcTablePolicy. 
using OpenEdge.DataAdmin.IArea.
//using OpenEdge.DataAdmin.ICdcTablePolicyField.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndexSet.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.ICdcFieldPolicySet.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.CdcTablePolicyContext. 
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext.
using OpenEdge.DataAdmin.Error.CreateOnlyPropertyError.
using OpenEdge.DataAdmin.Error.InvalidPropertyValueError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.CdcTablePolicyStateEnum.
using OpenEdge.DataAdmin.CdcTablePolicyLevelEnum.
using OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.CdcTablePolicy inherits AbstractPartitionParent implements ICdcTablePolicy: 
    
    define private variable mFPolicies as ICdcFieldPolicySet no-undo. 
    define private property CdcTablePolicyContext as CdcTablePolicyContext no-undo  
         get():                                                                        
             return cast(Context,CdcTablePolicyContext).                            
         end. 

    define public property DataArea as IArea no-undo 
        get():
            if not valid-object(DataArea) then
            do: 
                if valid-handle(mBuffer) and mBuffer::DataAreaName > ""  
                and valid-object(Service) then
                    DataArea = Service:GetArea(mBuffer::DataAreaName).            
            end.
            return DataArea.
        end.
        set(pDataArea as IArea):
            if not valid-object(pDataArea) then 
            do:
                undo, throw new UnknownValueError("DataArea").          
            end.
            if valid-handle(mBuffer) then
                Context:SetProperty(mBuffer:rowid,"DataAreaName",pDataArea:Name).
            DataArea = pDataArea.
        end. 

    define public property IndexArea as IArea no-undo 
   get():
        if not valid-object(IndexArea) then
        do: 
            if valid-handle(mBuffer) and mBuffer::IndexAreaName > "" 
            and valid-object(Service) then
                IndexArea = Service:GetArea(mBuffer::IndexAreaName).            
        end.
        return IndexArea. 
    end.
    set(pIndexArea as IArea):
        if not valid-object(pIndexArea) then 
        do:
            undo, throw new UnknownValueError("IndexArea").          
        end.   
        if valid-handle(mBuffer) then
            Context:SetProperty(mBuffer:rowid,"IndexAreaName",pIndexArea:Name).
        IndexArea = pIndexArea.
    end.  
	define public property EncryptPolicy as logical no-undo 
	get():
        if valid-handle(mBuffer) then
            return mBuffer::EncryptPolicy.
        else
            return EncryptPolicy. 
    end.
    set(pEncryptPolicy as logical):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::EncryptPolicy = pEncryptPolicy.
        end.
        else
            EncryptPolicy = pEncryptPolicy.
    end.  
    
    /*define public property CdcTablePolicyName as char no-undo 
    get():
        if valid-handle(mBuffer) then
            return mBuffer::CdcTablePolicyName.
        else
            return CdcTablePolicyName. 
    end.
    set(pName as char):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::CdcTablePolicyName = pName.
        end.
        else
            CdcTablePolicyName = pName.
    end.*/ 
    
     define public property ChangeTable as char no-undo  
    get():
        if valid-handle(mBuffer) then 
            return mBuffer::ChangeTable.        
        else
            return ChangeTable. 
    end.
    set(cName as char):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::ChangeTable = cName.
        end.
        else
            ChangeTable = cName.
    end.
    
    define public property ChangeTableOwner as char no-undo  
    get():
        if valid-handle(mBuffer) then 
            return mBuffer::ChangeTableOwner.
        else
            return ChangeTableOwner. 
    end.
    set(cName as char):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::ChangeTableOwner = cName.
        end.
        else
            ChangeTableOwner = cName.
    end.
    
    /*
    define public property SourceTableOwner as char no-undo  
    get():
        if valid-handle(mBuffer) then 
            return mBuffer::SourceTableOwner.
        else
            return SourceTableOwner. 
    end. */
    
    define public property CdcPolicyId as char no-undo  
    get():
        if valid-handle(mBuffer) then 
            return mBuffer::CdcPolicyId.
        else
            return CdcPolicyId. 
    end.
    set.

	define public property FieldPolicies as ICdcFieldPolicySet no-undo 
	get():
            if not valid-object(mFPolicies) then
                mFPolicies = cast(GetChildCollection("cdcFieldPolicies"),ICdcFieldPolicySet).
            return mFPolicies.
        end. 

	define public property Fields as IFieldList no-undo 
	get():
            if not valid-object( this-object:Fields) then
                this-object:Fields = cast(GetChildCollection("fields"),IFieldList).
            return this-object:Fields.
        end.
    protected set. 

	define public property IdentifyingField as logical no-undo 
	get():
        if valid-handle(mBuffer) then
            return mBuffer::IdentifyingField.
        else
            return IdentifyingField. 
    end.
    set(pIdentifyingField as logical):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::IdentifyingField = pIdentifyingField.
        end.
        else
            IdentifyingField = pIdentifyingField.
    end. 
/* 
	define public property IdentifyingFieldsUnique as logical no-undo 
	get():
        if valid-handle(mBuffer) then
            return mBuffer::IdentifyingFieldsUnique.
        else
            return IdentifyingFieldsUnique. 
    end.
    set(pIdentifyingFieldsUnique as logical):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).              
            mdefaultbuffer::IdentifyingFieldsUnique = pIdentifyingFieldsUnique.
        end.
        else
            IdentifyingFieldsUnique = pIdentifyingFieldsUnique.
    end.  	 
*/
	define public property Indexes as IIndexSet no-undo 
	 get():
            if not valid-object( this-object:Indexes) then
                this-object:Indexes = cast(GetChildCollection("indexes"),IIndexSet).
            return this-object:Indexes.
        end.
        private set.

	define public property Instance as CdcTablePolicyInstanceEnum no-undo 
	get():
        if valid-handle(mBuffer) then do:
           if mBuffer::Instance eq 0 then
            return CdcTablePolicyInstanceEnum:Current.
           if mBuffer::Instance eq 1 then
              return CdcTablePolicyInstanceEnum:Previous.
           if mBuffer::Instance eq 2 then
              return CdcTablePolicyInstanceEnum:Pending.
        end.
        else
            return Instance. 
    end.
    set. 

	define public property Level as CdcTablePolicyLevelEnum no-undo 
	get():
        if valid-handle(mBuffer) then do:
            if mBuffer::Level eq 1 then
                 return CdcTablePolicyLevelEnum:MinimalWithBitmap.
            else if mBuffer::Level eq 2 then
                 return CdcTablePolicyLevelEnum:Medium.
            else if mBuffer::Level eq 3 then
                 return CdcTablePolicyLevelEnum:Maximum.
            else return CdcTablePolicyLevelEnum:Minimal.
        end.
        else
            return Level. 
    end.
    set(pLevel as CdcTablePolicyLevelEnum):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).            
            mdefaultbuffer::Level = pLevel.
        end.
        else
            Level = pLevel.
    end. 

	define public property NumFields as integer no-undo 
	get():
        if valid-handle(mBuffer) then
            return mBuffer::NumFields.
        else
            return NumFields. 
    end.

	define public property State as CdcTablePolicyStateEnum no-undo 
	get():
        if valid-handle(mBuffer) then do:            
            if mBuffer::State eq 0 then
                 return CdcTablePolicyStateEnum:Active.
            else if mBuffer::State eq 1 then
                 return CdcTablePolicyStateEnum:Inactive.
            else return CdcTablePolicyStateEnum:Drop.           
        end.
        else
            return State. 
    end.
    set(pState as CdcTablePolicyStateEnum):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).            
            mdefaultbuffer::State = pState.
        end.
        else
            State = pState.
    end. 
    
    define public property LastModified as datetime-tz no-undo 
    get():
        if valid-handle(mBuffer) then do:              
                 return mBuffer::LastModified.                      
        end.
        else
            return LastModified. 
    end.
    set.
    
    define public property Misc as character extent 16 no-undo 
    get(i as int):
        if valid-handle(mBuffer) then do:              
                 return mBuffer::Misc(i).                      
        end.
        else
            return this-object:Misc[i].  
    end.
    set. 

	define public property Table as ITable no-undo 
	get():
            if not valid-object(this-object:Table) and valid-handle(mBuffer) and mBuffer::Tablename > "" then 
            do: 
               if valid-object(Service) then
                   return service:GetTable(mBuffer::Tablename,mbuffer::sourcetableowner). 
               else if valid-object(Context:TargetService) then
                   return Context:TargetService:GetTable(mBuffer::Tablename,mbuffer::sourcetableowner). 
            end.
            return this-object:Table.
        end.
        set(tbl as ITable):
             if not valid-object(tbl) then 
             do:
                 undo, throw new UnknownValueError("CDCTablePolicy:Table").          
             end.
            if valid-object(Service) then
                undo, throw new CreateOnlyPropertyError("CDCTablePolicy",Name,"Table").
                   
            if valid-handle(mBuffer) then do:
                mBuffer::TableName = tbl:Name.
                if tbl:NonPUBSchemaName <> ? then 
                    mBuffer::SourceTableOwner = tbl:NonPUBSchemaName.
                else mBuffer::SourceTableOwner = "PUB".                
            end.            
            this-object:Table = tbl.
        end.        

	method public logical AddFieldsFromData(  ):		
		AssertLoadFromData().
        CdcTablePolicyContext:FillNewFieldPolicies(this-object:Name).
	end method.

	method public logical AddFieldsFromData( input pcTokenString as character ):
		AssertLoadFromData().
        CdcTablePolicyContext:FillNewFieldPolicies(this-object:Name,pcTokenString).
	end method.

	method public logical AddFieldsFromData( input pcSubstituteBase as character, input pcSubstituteArgs as character ):
		AssertLoadFromData().
        CdcTablePolicyContext:FillNewFieldPolicies(this-object:Name,pcSubstituteBase,pcSubstituteArgs).
	end method.

	method override protected IDataAdminModel CreateLocalContext(  ):		
		return  new CdcTablePolicyContext().
	end method.
	
	method private void AssertLoadFromData():
        define variable policycntxt as CdcTablePolicyContext no-undo. 
        if valid-object(Service) then
            undo, throw AddFieldPolicyError("in an existing policy").
        if not valid-object(this-object:Table) then
            undo, throw AddFieldPolicyError("in a policy with no Table").
        if valid-object(mFPolicies) and mFPolicies:Count > 1 then
            undo, throw AddFieldPolicyError("when Field Policies already contains instances").
        /*if this-object:Fields:Count = 0 then
            undo, throw AddFieldPolicyError("in a policy with no fields").*/
        if not valid-object(Context) then
            undo, throw AddFieldPolicyError("in a policy not attached to or created by a service").
    end method.
    
    method protected char GetValidDefaultLevelList(): 
        return "0,1,2". 
    end method.
    
    constructor public CdcTablePolicy ( pname as character ):
        super (input pname).
    end constructor.
    constructor public CdcTablePolicy ( cntxt as IDataAdminModel, preq as IRequestInfo ):
        super (input cntxt, input preq).
    end constructor.
        
    constructor public CdcTablePolicy (  cntxt as IDataAdminModel ):
        super (input cntxt).
    end constructor.   
    
    method private UnsupportedOperationError AddFieldPolicyError(preason as char):
        return new UnsupportedOperationError("AddFieldPoliciesFromData cannot be called " + preason).
    end.
    
    define override public property DefaultDataArea as IArea no-undo 
    get.
    set.
    
    define override public property DefaultIndexArea as IArea no-undo 
    get.
    set.
    
    define override public property DefaultLobArea as IArea no-undo 
    get.
    set.
    
    define override public property DefaultAllocation as char no-undo 
    get.
    set.
end class.