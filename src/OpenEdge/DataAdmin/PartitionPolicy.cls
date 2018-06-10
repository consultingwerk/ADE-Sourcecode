/*************************************************************/
/* Copyright (c) 2013 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
 /*------------------------------------------------------------------------
    File        : PartitionPolicy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Jul 18 01:46:39 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.AbstractPartitionParent.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.PartitionPolicyContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext.
using OpenEdge.DataAdmin.Error.CreateOnlyPropertyError.
using OpenEdge.DataAdmin.Error.InvalidPropertyValueError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IArea.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IIndexSet.
using OpenEdge.DataAdmin.IPartitionPolicy.
using OpenEdge.DataAdmin.IPartitionPolicyDetailSet.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ITable.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.PartitionPolicy inherits AbstractPartitionParent implements IPartitionPolicy: 
     
     define private variable mDetails as IPartitionPolicyDetailSet no-undo. 
     
     define private property PartitionPolicyContext as PartitionPolicyContext no-undo 
         get():                                                                        
             return cast(Context,PartitionPolicyContext).                            
         end.                                                                         
        
	 define public override property DefaultAllocation as char no-undo                 
        get():
            if valid-handle(mBuffer) then
                return mBuffer::DefaultAllocation.
            else
                return DefaultAllocation. 
        end.
        set(pDefaultAllocation as char):
            if lookup(pDefaultAllocation,ValidDefaultAllocationList) = 0 then 
                undo, throw new InvalidPropertyValueError("PartitionPolicy",Name,"DefaultAllocation",pDefaultAllocation,ValidDefaultAllocationList).   
         
                
            if valid-handle(mBuffer) then
            do:
                Context:SetProperty(mBuffer:rowid,"DefaultAllocation",pDefaultAllocation).
            end.
            DefaultAllocation = pDefaultAllocation.
        end. 

    define public override property DefaultDataArea as IArea no-undo   
    get():
        if not valid-object(DefaultDataArea) then
        do: 
            /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
            if valid-handle(mBuffer) and valid-object(Service) then do:
                if mBuffer::DefaultDataAreaNumber <> 0 then 
                    return Service:GetArea(mBuffer::DefaultDataAreaNumber).
                else if mBuffer::DefaultDataAreaName > "" then
                    return Service:GetArea(mBuffer::DefaultDataAreaName).
            end.                    
        end.
        return DefaultDataArea.
    end.
    set(pDefaultDataArea as IArea):
        if not valid-object(pDefaultDataArea) then 
        do:
            undo, throw new UnknownValueError("DefaultDataArea").          
        end.
        if valid-handle(mBuffer) then
            Context:SetProperty(mBuffer:rowid,"DefaultDataAreaName",pDefaultDataArea:Name).
        DefaultDataArea = pDefaultDataArea.
    end .

    define public override property DefaultIndexArea as IArea no-undo     
        get():
        if not valid-object(DefaultIndexArea) then
        do: 
                /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
                if valid-handle(mBuffer) and valid-object(Service) then do:
                    if mBuffer::DefaultIndexAreaNumber <> 0 then 
                        return Service:GetArea(mBuffer::DefaultIndexAreaNumber).
                    else if mBuffer::DefaultIndexAreaName > "" then
                        return Service:GetArea(mBuffer::DefaultIndexAreaName).
                end.                    
        end.
        return DefaultIndexArea. 
    end.
    set(pDefaultIndexArea as IArea):
        if not valid-object(pDefaultIndexArea) then 
        do:
            undo, throw new UnknownValueError("DefaultIndexArea").          
        end.   
        if valid-handle(mBuffer) then
            Context:SetProperty(mBuffer:rowid,"DefaultIndexAreaName",pDefaultIndexArea:Name).
        DefaultIndexArea = pDefaultIndexArea.
    end.  

    define public override property DefaultLobArea   as IArea no-undo    
    get():
        
        if not valid-object(DefaultLobArea) then
        do: 
                /* do NOT assign since the setter changes data and will set row-modified
                      (the area is cached in the service) */
                if valid-handle(mBuffer) and valid-object(Service) then do:
                    if mBuffer::DefaultLobAreaNumber <> 0 then 
                        return Service:GetArea(mBuffer::DefaultLobAreaNumber).
                    else if mBuffer::DefaultDataAreaName > "" then
                        return Service:GetArea(mBuffer::DefaultLobAreaName).
                end.                   
        end.
        return DefaultLobArea. 
    end.
    set(pDefaultLobArea as IArea):
        if not valid-object(pDefaultLobArea) then 
        do:
           undo, throw new UnknownValueError("DefaultLobArea").          
        end.         
        if valid-handle(mBuffer) then
            Context:SetProperty(mBuffer:rowid,"DefaultLobAreaName",pDefaultLobArea:Name).
        DefaultLobArea = pDefaultLobArea.
    end. 

	define public property Details as IPartitionPolicyDetailSet no-undo 
	    get():
            if not valid-object(mDetails) then
                mDetails = cast(GetChildCollection("partitionPolicyDetails"),IPartitionPolicyDetailSet).
            return mDetails.
        end.
         
    define public property Fields as IFieldList no-undo 
        get():
            define variable oTable as handle no-undo. 
            if not valid-object( this-object:Fields) then do:
               /* if not saved yet then we need the have the table's fields 
                   on the client, so the polciyfield can join to it. */
                if Created and valid-object(this-object:Table) then
                    this-object:Table:Fields.  
                this-object:Fields = cast(GetChildCollection("fields"),IFieldList).
            end.
            return this-object:Fields.
        end.
        protected set.

        
	define public property HasRange as logical no-undo 
    get():
        if valid-handle(mBuffer) then
            return mBuffer::HasRange.
        else
            return HasRange. 
    end.
	set(phasrange as log):
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::HasRange = phasrange.
        end.
        else
            HasRange = phasrange.
	end.    
    
    /** Type  read only 
         List, List-range or Range -  */    
    define public property Type    as logical no-undo         
        get():
        if valid-handle(mBuffer) then
            return mBuffer::Type.
        else
            return Type. 
    end.  

    /** HasComposite  read only */    
    define public property HasComposite    as logical no-undo         
        get():
        if valid-handle(mBuffer) then
            return mBuffer::HasComposite.
        else
            return HasComposite. 
    end.  
    
    define public property IsCompositeReadOnly as logical no-undo 
    get():
        if valid-handle(mBuffer) then
            return mBuffer::isCompositeReadOnly.
        else
            return isCompositeReadOnly. 
    end.
    set(pisCompositeReadOnly as log):
        if this-object:Created then
            undo, throw new ReadOnlyPropertyError("PartitionPolicy",Name,"IsCompositeReadOnly",PartitionPolicyContext:CreateReadOnlyError).
        
        if valid-handle(mBuffer) then
        do:
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::isCompositeReadOnly = pisCompositeReadOnly.
        end.
        else
            isCompositeReadOnly = pisCompositeReadOnly.
    end.    
        
    /* mistake 11.4 .. would always give error */ 
	define public property IsReadOnly as logical no-undo 
    get.
  
    set(pIsReadOnly as log):
        undo, throw new ReadOnlyPropertyError("PartitionPolicy",Name,"IsReadOnly").   
    end.    
    
	define public property NumFields as integer no-undo 
    get():
        if valid-handle(mBuffer) then
            return mBuffer::NumFields.
        else
            return NumFields. 
    end.
   
	define public property Table as ITable no-undo 
        get():
            if valid-object(this-object:Table) = false
            and valid-handle(mBuffer) then 
            do: 
               if valid-object(Service) then
               do:
                   if mBuffer::Tablename > "" then
                   return service:GetTable(mBuffer::Tablename). 
                   else
                       return service:GetTable(mBuffer::ObjectNumber).
               end.     
               else if valid-object(Context:TargetService) then
               do:
                   if mBuffer::Tablename > "" then
                   return Context:TargetService:GetTable(mBuffer::Tablename). 
                   else
                       return Context:TargetService:GetTable(mBuffer::ObjectNumber). 

               end.
            end.
            return this-object:Table.
        end.
        set(tbl as ITable):
             if not valid-object(tbl) then 
             do:
                 undo, throw new UnknownValueError("PartitionPolicy:Table").          
             end.
            if valid-object(Service) then
                undo, throw new CreateOnlyPropertyError("PartitionPolicy",Name,"Table").
                   
            /** need to set this  immediately, since it is needed to 
                realize/create Fields collection h */ 
            if valid-handle(mBuffer) then
                mBuffer::TableName = tbl:Name.
            this-object:Table = tbl.
        end.   
              
        
    /** The local indexes of the policy 
        shorthand for table:Indexes where islocal
        editable in new policy (to make indexes local in same trans) 
        must match table and Fields  */
    define public property Indexes as IIndexSet no-undo 
        get():
            if not valid-object( this-object:Indexes) then do:
                /* if not saved yet then we need the have the table's indexes 
                   on the client, so the policyindexes can join to it. */
                if Created and valid-object(this-object:Table) then
                    this-object:Table:Indexes.  
                 
                this-object:Indexes = cast(GetChildCollection("indexes"),IIndexSet).
            end.    
            return this-object:Indexes.
        end.
        private set.
    
    method protected override char GetValidDefaultAllocationList(): 
        return "Immediate,None".
    end method.   
         
	constructor public PartitionPolicy ( pname as character ):
		super (input pname).
	end constructor.

	constructor public PartitionPolicy ( cntxt as IDataAdminModel, preq as IRequestInfo ):
		super (input cntxt, input preq).
	end constructor.
		
	constructor public PartitionPolicy (  cntxt as IDataAdminModel ):
		super (input cntxt).
	end constructor.
   
	method override protected IDataAdminModel CreateLocalContext(  ):
		return  new PartitionPolicyContext().  
	end method.
	
	 /* if lazy datasource none of the arename fields will have data 
       it is sufficent to check one of them - super does not have 
       area  - default may have...  */ 
    method protected override logical NeedsRefresh():
        return valid-handle(mBuffer) and mBuffer::DefaultDataAreaName = "".
	end method.
	
	 /* populate Details from data */
    method public logical AddDetailsFromData():
        AssertLoadFromData().
        PartitionPolicyContext:FillNewDetails(this-object:Name).
    end method.   
	 /* populate Details from data using token string to assign name 
       @param TokenString format XX${<property>}X}  where X is any fixed mask char 
        (except "$~{" or "~}" ) 
       example  "$~{TableName~}-$~{PartitionPolicyName~}-$~{Values[3]}-$~{Values[2]}".
       valid properties are TableName PartitionPolicyName Values[i] (i = field number)
       
     */
    method public logical AddDetailsFromData(pcTokenString as char):
        AssertLoadFromData().
        PartitionPolicyContext:FillNewDetails(this-object:Name,pcTokenString).
    end method.  
         
   /* populate Details from data using substitute string and comma separated list
      of properties to assign name 
       @param TokenString tokens in &n format as ABL substitute statement (max 9) 
       @param Propertiesg comma separated list of props 
       valid properties are TableName PartitionPolicyName Values[i] (i = field number)
     */
    method public logical AddDetailsFromData(pcSubstituteBase as char,pcSubstituteArgs as char):
        AssertLoadFromData().
        PartitionPolicyContext:FillNewDetails(this-object:Name,pcSubstituteBase,pcSubstituteArgs).
    end method.
    
    /** override to check for indexes -which will be found, but cause error when building dataset with bad join */
    method public override void ExportTree(pcfile as char,pcCollectionlist as char):
        if lookup("Indexes",pcCollectionList) > 0 then
            undo, throw new UnsupportedOperationError("Export of Indexes collection. Use LocalIndexes instead.").
        if lookup("Fields",pcCollectionList) > 0 then
             undo, throw new UnsupportedOperationError("Export of Fields collection. Use PartitionPolicyFields instead.").                    
        super:ExportTree(pcfile,pcCollectionlist). 
    end method.
    
    method private void AssertLoadFromData():
        define variable policycntxt as PartitionPolicyContext no-undo. 
        if valid-object(Service) then
            undo, throw AddDetailError("in an existing policy").
        if not valid-object(this-object:Table) then
            undo, throw AddDetailError("in a policy with no Table").
        if valid-object(mDetails) and mDetails:Count > 1 then
            undo, throw AddDetailError("when Details already contains instances").
        if this-object:Fields:Count = 0 then
            undo, throw AddDetailError("in a policy with no fields").
        if not valid-object(Context) then
            undo, throw AddDetailError("in a policy not attached to or created by a service").
    end method.
    
    method private void ConvertTokensToSubstitute( pctemplate as char ,output pcresult  as char, output pcTokens as char):
        define variable i as integer no-undo.
        define variable iPos as integer no-undo.
        define variable iEndPos  as integer no-undo.
        define variable cToken as character no-undo.
        define variable cRest as character no-undo.
        define variable iCnt as integer no-undo.
        cRest = pctemplate.
        do i = 1 to length(pctemplate):
            iPos = index(cRest,"&~{").
            if iPos > 0 then 
            do:
                if iPos > 1 then
                   pcResult = pcResult + substr(cRest,1,iPos - 1).
                assign
                    iEndPos = index(cRest,"~}")  
                    cToken  = substr(cRest,iPos + 2,iEndPos - iPos - 2) 
                    iCnt = iCnt + 1   
                    pcTokens = pcTokens + (if pcTokens = "" then "" else ",") + cToken 
                    pcResult = pcResult + '&' + string(iCnt) 
                    cRest = substr(cRest,iEndPos + 1).
            end. 
            else  do:      
               pcResult = pcResult + cRest. 
               leave.
            end.  
        end.
        
    end method.
        
	method private UnsupportedOperationError AddDetailError(preason as char):
	    return new UnsupportedOperationError("AddDetailsFromData cannot be called " + preason).
	end.
	
end class.