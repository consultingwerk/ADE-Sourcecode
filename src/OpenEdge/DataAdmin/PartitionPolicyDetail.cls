/* ***********************************************************/
/* Copyright (c) 2013,2014 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : Partition policy detail		 
    Author(s)   : hdaniels
    Created     : Thu Aug 01 21:25:49 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
 

routine-level on error undo, throw.

using OpenEdge.DataAdmin.AbstractPartitionOwner from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminModel from propath.
using OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Error.IllegalOperationError from propath.
using OpenEdge.DataAdmin.Error.ReadOnlyPropertyError from propath.
using OpenEdge.DataAdmin.Error.UnknownValueError from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IDataAdminService from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.ITable from propath.

class OpenEdge.DataAdmin.PartitionPolicyDetail inherits AbstractPartitionOwner implements IPartitionPolicyDetail: 
         /* avoid set ov values when sizing set */
     define private variable mInitialized as logical no-undo.  
     
     define protected property DetailContext  as PartitionPolicyDetailContext no-undo                 
        get() :
            return cast(this-object:Context,PartitionPolicyDetailContext).
        end.
    
     define public property PartitionPolicy as IPartitionPolicy no-undo                 
        get():
            define variable currentservice as IDataAdminService no-undo.
            if not valid-object(PartitionPolicy) then
            do:
                if valid-handle(mBuffer) then
                do:
                    currentservice = GetLookupService().
                    if valid-object(currentservice) then    
                        return currentservice:GetPartitionPolicy(mBuffer::PartitionPolicyName).
                end. 
            end.
            return PartitionPolicy. 
        end.
         
    /** Returns true if this is a composite partition (shared default)  */
    define public property IsComposite as logical  no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsComposite.
            else
                return IsComposite. 
        end. 
    
    /** true if the partitions are in transition (waiting for split merge)  */
    define public property IsSplitTarget as logical  no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsSplitTarget.
            else
                return IsSplitTarget. 
        end. 
        set(pIsSplitTarget as log):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsSplitTarget = pIsSplitTarget.
            end.
            IsSplitTarget = pIsSplitTarget.
        end.
   
    define public property IsReadOnly  as logical  no-undo  
        get():
            if valid-handle(mBuffer) then
                return mBuffer::IsReadOnly.
            else
                return IsReadOnly. 
        end. 
        set(pIsReadOnly as log):
            if valid-handle(mBuffer) then
            do:
                mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
                mdefaultbuffer::IsReadOnly = pIsReadOnly.
            end.
            IsReadOnly = pIsReadOnly.
        end. 
           
    define public property NumFields as int no-undo    
         get() :
             if valid-object(Service) then 
             do:
                 if NumFields = 0 then
                     NumFields = PartitionPolicy:NumFields.
                  return NumFields.      
             end. 
             if GetPolicyName() > "" then
                 return DetailContext:GetPolicyNumFields(GetPolicyName()).
             return 0.
            
         end.
         private set.
         
	 define public override property DefaultAllocation as char no-undo                 
        get():
            if valid-object(PartitionPolicy) then
                return PartitionPolicy:DefaultAllocation.
            else if valid-handle(mBuffer) then
                return mBuffer::DefaultAllocation.
            else
                return DefaultAllocation. 
        end.
        set(pDefaultAllocation as char):
            undo, throw new ReadOnlyPropertyError("PartitionPolicyDetail",Name,"DefaultAllocation"," The default allocation is only editable on the parent PartitionPolicy" ).   
/*                                                                                          */
/*            if valid-handle(mBuffer) then                                                 */
/*            do:                                                                           */
/*                Context:SetProperty(mBuffer:rowid,"DefaultAllocation",pDefaultAllocation).*/
/*            end.                                                                          */
/*            DefaultAllocation = pDefaultAllocation.                                       */
        end. 

    define public override property DefaultDataArea as IArea no-undo   
        get():
            if not valid-object(DefaultDataArea) then
            do: 
                if valid-handle(mBuffer) and mBuffer::DefaultIndexAreaName > "" 
                and valid-object(Service) then
                   DefaultDataArea = Service:GetArea(mBuffer::DefaultDataAreaName).            
            end.
            return DefaultDataArea.
        end.
        set(pDefaultDataArea as IArea):
            if not valid-object(pDefaultDataArea) then 
            do:
                undo, throw new UnknownValueError("DefaultDataArea").          
            end.
            if valid-handle(mBuffer) then
                this-object:Context:SetProperty(mBuffer:rowid,"DefaultDataAreaName",pDefaultDataArea:Name).
            DefaultDataArea = pDefaultDataArea.
        end .

    define public override property DefaultIndexArea as IArea no-undo     
        get():
        if not valid-object(DefaultIndexArea) then
        do: 
            if valid-handle(mBuffer) and mBuffer::DefaultIndexAreaName > "" 
            and valid-object(Service) then
                DefaultIndexArea = Service:GetArea(mBuffer::DefaultIndexAreaName).            
        end.
        return DefaultIndexArea. 
    end.
    set(pDefaultIndexArea as IArea):
        if not valid-object(pDefaultIndexArea) then 
        do:
            undo, throw new UnknownValueError("DefaultIndexArea").          
        end.   
        if valid-handle(mBuffer) then
            this-object:Context:SetProperty(mBuffer:rowid,"DefaultIndexAreaName",pDefaultIndexArea:Name).
        DefaultIndexArea = pDefaultIndexArea.
    end.  

    define public override property DefaultLobArea   as IArea no-undo    
    get():
        if not valid-object(DefaultLobArea) then
        do: 
            if valid-handle(mBuffer) and mBuffer::DefaultLobAreaName > "" 
            and valid-object(Service) then
                DefaultLobArea = Service:GetArea(mBuffer::DefaultLobAreaName).            
        end.
        return DefaultLobArea. 
    end.
    set(pDefaultLobArea as IArea):
        if not valid-object(pDefaultLobArea) then 
        do:
           undo, throw new UnknownValueError("DefaultLobArea").          
        end.         
        if valid-handle(mBuffer) then
            this-object:Context:SetProperty(mBuffer:rowid,"DefaultLobAreaName",pDefaultLobArea:Name).
        DefaultLobArea = pDefaultLobArea.
    end. 
    
    define public override property IsDataEnabled as logical no-undo  init true        
    get():
        if valid-handle(mBuffer) then
            return mBuffer::IsDataEnabled.
        else
            return IsDataEnabled. 
    end.
    set(pIsDataEnabled as logical):
        
        undo, throw new ReadOnlyPropertyError("PartitionPolicyDetail",Name,"IsDataEnabled"  ).   
        
/*        if valid-handle(mBuffer) then                      */
/*        do:                                                */
/*            mDefaultBuffer:find-by-rowid(mBuffer:rowid).   */
/*            mdefaultbuffer::IsDataEnabled = pIsDataEnabled.*/
/*        end.                                               */
/*        else                                               */
/*            IsDataEnabled = pIsDataEnabled.                */
    end. 
    
	define public property Values as character extent no-undo 
	    get(i as int):
            if valid-handle(mBuffer) and mInitialized then
                return mBuffer::StringValues(i).
            else
                return this-object:Values[i]. 
        end.     
		protected set(pval as char,i as int):
		    if valid-handle(mBuffer) and mInitialized then
                SetStringValue("character",pval,i).
            else
                this-object:Values[i] =  pval.
	    end.
		    
	constructor public PartitionPolicyDetail (pname as character ):
		super (pname).
	end constructor.

	constructor public PartitionPolicyDetail (  cntxt as IDataAdminModel,  preq as IRequestInfo ):
		super ( cntxt,  preq).
	    if not Created then 
        do:
            extent(this-object:Values) = NumFields.
            mInitialized = true.
        end. 
	end constructor.
		
	constructor public PartitionPolicyDetail (  cntxt as IDataAdminModel ):
		this-object ( cntxt,?).
	end constructor.
	
    method protected override char GetValidDefaultAllocationList(): 
        return "Immediate,None".
    end method. 
      
    method private char GetPolicyName( ):
        if valid-handle(mBuffer) then
            return mBuffer::PartitionPolicyName.
        return "".
    end.
    
    method char GetDataType(i as int ):
        if valid-handle(mBuffer) then
        do:
            return DetailContext:GetPolicyFieldDataType(mBuffer::PartitionPolicyName,i).
        end.    
        return "".
    end.    
	method override protected IDataAdminModel CreateLocalContext(  ):
		return new PartitionPolicyDetailContext().
	end method.

	method public void SetValue(  pval as character ):
		SetStringValue("character",pval).
	end method.

	method public void SetValue(  pval as character,  pidx as integer ):
	    SetStringValue("character",pval,pidx).
	end method.

	method public void SetValue(  pval as logical ):
        SetStringValue("logical",string(pval)).
    end method.

	method public void SetValue(  pval as logical,  pidx as integer ):
	    SetStringValue("logical",string(pval),pidx).
    end method.

	method public void SetValue(  pval as integer ):
	    SetStringValue("integer",string(pval)).
    end method.

	method public void SetValue(  pval as integer,  pidx as integer ):
        SetStringValue("integer",string(pval),pidx).
	end method.

	method public void SetValue(  pval as int64 ):
	    SetStringValue("int64",string(pval)).
 	end method.

	method public void SetValue(  pval as int64,  pidx as integer ):
        SetStringValue("int64",string(pval),pidx).
 	end method.

	method public void SetValue(pval as decimal):
        SetStringValue("decimal",string(pval)).
	end method.

	method public void SetValue( pval as decimal, pidx as integer ):
        SetStringValue("decimal",string(pval),pidx).
	end method.

	method public void SetValue(  pval as date ):
        SetStringValue("date",string(pval)).
	end method.

	method public void SetValue(  pval as date,  pidx as integer ):
        SetStringValue("date",string(pval),pidx).
	end method.

	method public void SetValue(  pval as datetime ):
        SetStringValue("datetime",string(pval)).
 	end method.

	method public void SetValue(  pval as datetime,  pidx as integer ):
        SetStringValue("datetime",string(pval),pidx).
    end method.

	method public void SetValue(  pval as datetime-tz ):
        SetStringValue("datetime-tz",string(pval)).
 	end method.

	method public void SetValue(  pval as datetime-tz,  pidx as integer ):
        SetStringValue("datetime-tz",string(pval),pidx).
	end method.
	
    method public override logical Allocate(  ):
        
        if (valid-object(PartitionPolicy) and not valid-object(PartitionPolicy:Table)) 
        or mBuffer::Tablename = "" 
        or mBuffer::Tablename = ? then
            undo, throw new IllegalOperationError("You cannot allocate a new PartitionPolicyDetail when the parent PartitionPolicy:Table is undefined or invalid." ).  
        
        if Created and hasData() then
            undo, throw new IllegalOperationError("You cannot allocate a new PartitionPolicyDetail for a table with data. The data will remain allocated in the default composite partition when the detail is created." ).  
    
        IsAllocated = true.
        return Partitions:Allocate().
    end method.
    
    method protected void SetStringValue(ptype as char,  pval as character):
        if NumFields > 1 then
            undo, throw new IllegalOperationError("Cannot use SetValue(val). The Policy has " + string(NumFields) + " fields. Use SetValue(value,index)"). 
   
        SetStringValue(ptype,pval,1).
    end.  
    
    method protected void SetStringValue(pctype as char,pval as character, pidx as integer):
/*        define variable msgnoparent as character no-undo                                    */
/*             init "Cannot set value in a detail that does not belong to a PartitionPolicy.".*/
        if valid-handle(mBuffer) and getPolicyName() > "" then
        do:
/*            if getPolicyName() = "" then                           */
/*                undo, throw new IllegalOperationError(msgnoparent).*/
            AssertSet(pidx).
            pval = DetailContext:GetAmericanValue(getPolicyName(),pctype,pval,pidx).
            mDefaultBuffer:find-by-rowid(mBuffer:rowid).  
            mdefaultbuffer::stringvalues(pidx) = pval.
        end.
        else do:
            AddLocalExtent(pval,pidx).  
        end.    
    end.     
    
    method private char extent AddLocalExtent(pcval as char,pi as int) :
        define variable i as integer no-undo.
        define variable cOld as character extent no-undo.
        if pi > extent(this-object:Values) or  extent(this-object:Values) = ? then
        do:
            cold = this-object:Values. 
            extent(this-object:Values) = ?.
            extent(this-object:Values) = pi.
            do i = 1 to extent(cold):
                this-object:Values[i] = cold[i].
            end.            
        end.
        this-object:Values[pi] = pcval.       
    end.     
    
    method public override void Attach(cntxt as IDataAdminContext):  
         define variable cValues as character extent no-undo.
         define variable i as integer no-undo.
         if extent(this-object:Values) <> ? and Numfields = 0 then
         do:
             cValues = this-object:Values.
         end.     
         super:Attach(cntxt).
         if NumFields > 0 then
         do:
             extent(this-object:Values) = ?.
             extent(this-object:Values) = NumFields.
             mInitialized = true.
             if extent(cValues) <> ? then
             do:
                 if extent(cValues) > NumFields then 
                     undo, throw new IllegalOperationError("The policy has " + string(Numfields) + " fields while the detail has " + string(extent(cValues)) + " values."). 
                 do i = 1 to extent(cValues):
                     this-object:Values[i] = cValues[i].
                 end.
             end.      
         end.
         else 
             mInitialized = true.
    end.
    
    method private void AssertSet ( i as int):
        define variable iNumcols as integer no-undo.
        iNumcols = NumFields.      
        if i = ? and iNumcols > 1 then
            undo, throw new IllegalOperationError("Cannot use SetValue(val). The Policy has " + string(inumcols) + " fields. Use SetValue(value,index)"). 
        if i > iNumcols  then
            undo, throw new IllegalArgumentError("Cannot set value for number " + string(i) + ". The Policy has " + string(inumcols) + " fields."). 
    end method. 
    
/*    method void AssertSet (pcDatatype as char,i as int):                                                                                                                    */
/*        define variable iNumcols as integer no-undo.                                                                                                                        */
/*        define variable cDataType as character  no-undo.                                                                                                                    */
/*        if getPolicyName() = "" then                                                                                                                                        */
/*            undo, throw new IllegalOperationError("Cannot set value in a detail that does not belong to a PartitionPolicy.").                                               */
/*        iNumcols = NumFields.                                                                                                                                               */
/*        if i = ? and iNumcols > 1 then                                                                                                                                      */
/*            undo, throw new IllegalOperationError("Cannot use SetValue(val). The Policy has " + string(inumcols) + " fields. Use SetValue(value,index)").                   */
/*        if i > iNumcols  then                                                                                                                                               */
/*            undo, throw new IllegalArgumentError("Cannot set value for number " + string(i) + ". The Policy has " + string(inumcols) + " fields.").                         */
/*        cDataType = GetDataType(i).                                                                                                                                         */
/*        if cDataType <> pcDatatype  then                                                                                                                                    */
/*            undo, throw new IllegalOperationError("Field number " + string(i ) + " is a " + quoter(cDataType) + " field. Use SetValue(value,index) with native data-type.").*/
/*                                                                                                                                                                            */
/*    end method.                                                                                                                                                             */
    
    method protected override void AssertPartitions():
        if Created then 
        do:
            if getPolicyName() = "" then 
                undo, throw new IllegalOperationError("Partitions are not available in a new PartitionPolicyDetail that does not belong to a PartitionPolicy.").  
            
            if Name = "" or name = ? then
                undo, throw new IllegalOperationError("Partitions are not available in a new PartitionPolicyDetail that does not have a name.").  
            
            if (valid-object(PartitionPolicy) and not valid-object(PartitionPolicy:Table))
                or mBuffer::Tablename = "" 
                or mBuffer::Tablename = ? then
            
                undo, throw new IllegalOperationError("Partitions are not available in a new PartitionPolicyDetail when the parent PartitionPolicy:Table is undefined or invalid." ).  
             
            if hasData() then
                undo, throw new IllegalOperationError("Partitions are not available in a new PartitionPolicyDetail for a table with data. These Partitions cannot be accessed until the PartitionPolicyDetail is split from the composite." ).  
        end.
        
    end method.
       
    /* @TODO Add hasData to ITable */
    method private logical hasData () :
       define variable cTable as character no-undo.
       define variable tbl as ITable no-undo.
       define variable cTablename as character no-undo.
       if valid-object(PartitionPolicy) then
       do:
          tbl =  PartitionPolicy:Table. 
          
         /*  Need to validate this here since checking for data for multi-tenant is difficult (if super tenant) */
           if tbl:IsMultitenant then 
           undo, throw new IllegalOperationError("The PartitionPolicy:Table is a multi-tenant table." ).  
          cTablename = tbl:name.
       end.
       else 
          cTablename = mBuffer::Tablename.
       return bufferHasData( cTablename ). 
        
    end method.
    
    /* @TODO move to some utility and expose in ITable */
    method logical bufferHasData (pctable as char):
        define variable hBuffer as handle no-undo.
        create buffer hBuffer for table pcTable.  
        hBuffer:find-first ().
        return true.
        catch e as Progress.Lang.Error :
            if e:getMessageNum(1) = 565 then
                return false.        
            
            undo, throw new IllegalOperationError("The PartitionPolicy:Table is not accessible in the current session." ).  
        end catch.
        finally:
            delete object hBuffer no-error.		
        end finally.    
    end method.
    
end class.