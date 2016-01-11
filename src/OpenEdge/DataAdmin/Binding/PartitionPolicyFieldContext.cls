/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
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
   Created     : Jul 2013
   Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.ExtentContext.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext.
using OpenEdge.DataAdmin.Binding.Query.AreaExtentQuery.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.Query.PartitionPolicyFieldQuery.
using OpenEdge.DataAdmin.Binding.RowBuffer.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.CreateOnlyPropertyError.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.InvalidPropertyValueError.
using OpenEdge.DataAdmin.Error.UnknownValueError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.Error.ValidationError.
using OpenEdge.DataAdmin.ExtentList.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.IPartitionPolicyField.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.Message.ITableResponse.
using OpenEdge.DataAdmin.PartitionPolicyField.
using OpenEdge.DataAdmin.Support.PartitionPolicyFieldList.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext inherits DataAdminContext implements IDataAdminContext: 
    
     
    {daschema/partitionpolicyfield.i}
    {daschema/partitionpolicy.i REFERENCE-ONLY}
   
    /* NOTE: needed for tracking changes*/ 
    define private dataset dsPolicyField serialize-name "root" for ttPartitionPolicyfield.
    
    define buffer bPartitionPolicyField for ttPartitionPolicyField. 
    define temp-table copytable reference-only like ttPartitionPolicyField.  
      
    define public override property TableHandle as handle no-undo 
        get():
            return temp-table ttPartitionPolicyField:handle.
        end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "PartitionPolicyName,FieldName". 
        end.    
     
    define public override property Count as integer init ? no-undo  
        get(): 
            
            if Count = ? then
            do:
                Count = 0.
                for each bPartitionPolicyField:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public PartitionPolicyFieldContext():
        super ("PartitionPolicyField").
        Lazy = false.
    end constructor.
        
	constructor public PartitionPolicyFieldContext ( pscope as ISchemaScope):
        super ("PartitionPolicyField",pscope).
        Lazy = false.
    end constructor.
	
	method public override character GetJoinFields(parentid as char):
        if parentid = "PartitionPolicies" then 
             return "Name,PartitionPolicyName".
        return "".     
    end.
	
	/** DataRefreshed from server cannot use copy-temp-table since the primary index
	    is on areanumber */
	method private void RefreshTable(input table ttPartitionpolicy):
/*	    define buffer bPartitionPolicyField for ttPartitionPolicyField.                                                   */
/*        define variable lTrack as logical no-undo.                                                                     */
/*        define variable i as integer no-undo.                                                                          */
/*        define variable cfieldName as character no-undo.                                                               */
/*        lTrack = temp-table ttPartitionPolicyField:tracking-changes.                                                   */
/*        temp-table ttPartitionPolicyField:tracking-changes = FALSE.                                                    */
/*                                                                                                                       */
/*        for each ttPartitionpolicy on error undo, throw:                                                               */
/*            do i = 1 to extent(ttPartitionpolicy.FieldNames):                                                          */
/*                cfieldName = ttPartitionpolicy.FieldNames[i].                                                          */
/*                if cFieldName > "" then                                                                                */
/*                do:                                                                                                    */
/*                    find bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = ttPartitionpolicy.Name*/
/*                                                 and bPartitionPolicyField.number              = i no-error.           */
/*                                                                                                                       */
/*                    if not avail bPartitionPolicyField then                                                            */
/*                    do:                                                                                                */
/*                        create bPartitionPolicyField.                                                                  */
/*                        bPartitionPolicyField.TableName = ttPartitionpolicy.TableName                                  */
/*                        bPartitionPolicyField.Number = i.                                                              */
/*                    end.                                                                                               */
/*                                                                                                                       */
/*                end.                                                                                                   */
/*            end.                                                                                                       */
/*                                                                                                                       */
/*        end.                                                                                                           */
/*        finally:                                                                                                       */
/*            temp-table ttPartitionPolicyField:tracking-changes = lTrack.                                               */
/*        end finally.                                                                                                   */
    end method.
	 
	/* As of current the numbers are copied and will give error if already exists 
	 - @todo  a more correct way would be to not copy numbers and increment them instead, 
	   but this would need to be handled per policy  (the use case may be  rare though) */ 
    method private void CopyTable(input table copyTable):
        define variable dataerror as DataContextError no-undo.      
        define variable lTrack as logical no-undo.
        
        lTrack = temp-table ttPartitionPolicyField:tracking-changes.
        
        for each copytable  on error undo, throw:  
             
            do on error undo, throw:
                /* check both unique keys - see method comment*/
                find bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = copytable.PartitionPolicyName 
/*                                             and bPartitionPolicyField.TableName  = copytable.TableName*/
                                             and bPartitionPolicyField.FieldName  = copytable.FieldName no-error.
                if not avail bPartitionPolicyField then                             
                     find bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = copytable.PartitionPolicyName 
                                                and bPartitionPolicyField.Number  = copytable.Number no-error.
                                            
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bPartitionPolicyField then
                do:
                    create bPartitionPolicyField.
                    assign 
                       bPartitionPolicyField.PartitionPolicyName = copytable.PartitionPolicyName  
                       bPartitionPolicyField.TableName = copytable.TableName
                       bPartitionPolicyField.FieldName = copytable.FieldName
                       bPartitionPolicyField.Number = copytable.Number
                       .         
                end.    
                catch e as Progress.Lang.Error :
                    delete bPartitionPolicyField.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("PartitionPolicyField",e).
                    else 
                        dataError:AddMessage(e).                     
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttPartitionPolicyField:tracking-changes = true.
        for each copytable:
            create ttPartitionPolicyField.    
            Count = Count + 1.
            buffer-copy copytable  to ttPartitionPolicyField.   
            OnRowCreated().
        end.
        finally:
           temp-table ttPartitionPolicyField:tracking-changes = lTrack.
        end finally.
            
    end method.  
    
    method protected override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.   
     
    method private character GetCreateError(newField as IPartitionPolicyField):
        return GetCreateError(newField:Field:Name). 
    end method.
    
    method public character extent GetFieldNames(pcPolicy as char):
        define variable i as integer no-undo.
        define variable cFields15 as character extent 15 no-undo.
        define variable cFields as character extent no-undo.
  
        for each bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = pcPolicy :
            i = i + 1.
            cFields15[i] = bPartitionPolicyField.FieldName. 
        end. 
        if i = 0 then 
           return cFields.
        extent(cFields) = i.
        do i = 1 to extent(cFields):
           cFields[i] = cFields15[i] .
        end.   
        return cFields. 
        catch e as Progress.Lang.Error :
            /* a bit late too detect this . other validation exist that shoukld avoid this , but just in case  */ 
            if e:GetMessageNum(1) = 26 then
                undo, throw GetSizeError("").
            undo, throw e.
         
        end catch.
    end method.
    
    method private character GetCreateError(newField as IField):
        return GetCreateError(newField:Name). 
    end method.
  
  	/* override - unsupported in super */
	method protected override void InitRow():
        undo, throw new UnsupportedOperationError("CreateRow with name in PartitionPolicyFieldContext").
/*         create ttPartitionPolicyField.*/
    end method.
    
	/* override to add TableName not in foreign value   */
    method protected override void ReadRowForParent(pRow as IRow,json as JSONObject).
        define variable iCount as integer no-undo.
        define variable cTableName as character no-undo.
        if buffer ttPartitionPolicyField:row-state = row-created then
        do:
            cTableName = pRow:FieldValue("TableName").
            ttPartitionPolicyField.TableName = cTableName.
           
        end.
        ReadRow(json,GetClientKeyFields()).
        if buffer ttPartitionPolicyField:row-state = row-created then
        do:
            iCount = int(cast(prow,RowBuffer):FieldValue("NumFields")) + 1. 
            cast(prow,RowBuffer):AssignFieldValue("NumFields",iCount).     
        end.    
    end method. 
    
	method public override void InitRow(pname as char):
        undo, throw new UnsupportedOperationError("CreateRow with name in PartitionPolicyFieldContext").
	end method.
    
    method public override void InitRow(pid as int):
        undo, throw new UnsupportedOperationError("CreateRow with int key in PartitionPolicyFieldContext. The PartitionPolicyField:Number will be incremented when the PartitionPolicyField is added to the Area." ).
    end method.
    

    /* currently this will always throw error  */
    method public override void CreateRow(entity as IDataAdminElement):
        if type-of(entity,IField) then
            CreateRow(cast(entity,IField)).    
        else if type-of(entity,IPartitionPolicyField) then
            CreateRow(cast(entity,IPartitionPolicyField)).    
        else 
            undo, throw new IllegalArgumentError("Entity must be IField or IPartitionPolicyField").
    end method.
    
    method public void CreateRow(policyField as IPartitionPolicyField):
        undo, throw new UnsupportedOperationError("Create IPartitionPolicyField in PartitionPolicyField context without specifying PartitionPolicy parent.").      
    end method.
    
    method public void CreateRow(pfield as IField):
        undo, throw new UnsupportedOperationError("Create IField in PartitionPolicyField context without specifying PartitionPolicy parent.").      
    end method.
    
    method public override void CreateRowForParent(pRow as IRow,pentity as IDataAdminElement):
        AssertNotNull(pEntity,"entity"). 
        if type-of(pentity,IPartitionPolicyField) then  
        do:
            CreateRowForParent(pRow,cast(pentity,IPartitionPolicyField)).
        end.    
        else if type-of(pentity,IField) then  
        do:
            CreateRowForParent(pRow,cast(pentity,IField)).
        end.
        else 
            undo, throw new IllegalArgumentError("Cannot create " + pentity:getClass():TypeName +  " in PartitionPolicyField context.").    
    end.
    
    method public void CreateRowForParent(pRow as IRow,pPolicyField as IPartitionPolicyField):
        AssertNotNull(pPolicyField,"PartitionPolicyField").
        CreateRowForParent(prow,pPolicyField:Field).
    end method.
    
    /*  As of current this is "base" method for all CreateRowForParent (IRow,) overloads */
    method public void CreateRowForParent(pRow as IRow,pField as IField):
        define variable iCount as integer no-undo. 
        iCount = int(cast(prow,RowBuffer):FieldValue("NumFields")) + 1. 
        CreateRow(pRow:KeyValue,iCount,pField).
        cast(prow,RowBuffer):AssignFieldValue("NumFields",iCount). 
    end method.
    
    method public void CreateRow(pcParent as char,pinum as int,pField as IField):
        AssertNotNull(pField,"Field").
        CreateRow(pcParent,pField:Table:Name,pField:Name,pinum,pfield:DataType). 
    end method.
    
    method public void CreateRow(ppolicydetailname as char, pTable as char, pfieldname as char,piNum as int, pDatatype as char):
        define variable validateError as DataContextError no-undo.
        define variable lTrack as logical no-undo.
        if piNum > 15 then 
             undo, throw GetSizeError(ppolicydetailname,pfieldname) .
        lTrack = temp-table ttPartitionPolicyField:tracking-changes.
        temp-table ttPartitionPolicyField:tracking-changes = true.
        /*        ValidateArea(area).*/
        do on error undo, throw: 
            create ttPartitionPolicyField.
            assign 
                ttPartitionPolicyField.Number    = piNum 
                ttPartitionPolicyField.PartitionPolicyName = ppolicydetailname
                ttPartitionPolicyField.DataType  = pDataType
                ttPartitionPolicyField.TableName = pTable
                ttPartitionPolicyField.FieldName = pFieldName.
                
            Count = Count + 1.
            OnRowCreated().        
            catch e as Error:  
                delete ttPartitionPolicyField.
                undo, throw new DataContextError(GetCreateError(pFieldname),"PartitionPolicyField",e).  
            end catch.  
        end.
        finally:
            temp-table ttPartitionPolicyField:tracking-changes = lTrack.
        end.
    end method.
     
    method public void UpdatePartitionPolicyName(pcOldname as char, pcNewname as char):
        define variable lTrack as logical no-undo.
        define buffer bPartitionPolicyField for ttPartitionPolicyField.
        lTrack = temp-table ttPartitionPolicyField:tracking-changes.
        temp-table ttPartitionPolicyField:tracking-changes = false.
        for each bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = pcOldname:
            assign bPartitionPolicyField.PartitionPolicyName = pcNewname.
        end.    
        finally:
            temp-table ttPartitionPolicyField:tracking-changes = lTrack.
        end.
    end. 
     
        
/*     /** override to validate path and size */                                                                              */
/*    method protected override void ValidateProperty(pcfield as char,poldvalue as char,pnewvalue as char).                   */
/*        if valid-object(Service) then                                                                                       */
/*            undo, throw new CreateOnlyPropertyError("PartitionPolicyField",string(ttPartitionPolicyField.number),pnewValue).*/
/*        super:ValidateProperty(pcField,poldvalue,pnewvalue).                                                                */
/*        case pcfield:                                                                                                       */
/*/*            when "Path" then                            */                                                                */
/*/*                ValidatePath(ttPartitionPolicyField.Number,pnewvalue).*/                                                  */
/*            when "Size" then                                                                                                */
/*                ValidateSize(ttPartitionPolicyField.Number,pnewvalue).                                                      */
/*        end.                                                                                                                */
/*    end method.                                                                                                             */
    
/*    method public override void ValidateBuffer(phPartitionPolicyField as handle):                   */
/*        if phPartitionPolicyField::Isfixed  then                                                    */
/*             ValidateSize(phPartitionPolicyField::Number,string(phPartitionPolicyField::Size)).     */
/*                                                                                                    */
/*         /* done in DA  ValidatePath(phPartitionPolicyField::Number,phPartitionPolicyField::Path).*/*/
/*    end method.                                                                                     */

   /**      checked in data access, seems safer in case this is moved to a client
    
    method private void ValidatePath(piKey as int,pnewvalue as char).  
        if pnewvalue <> "" then
        do:
            file-info:file-name = pnewvalue.
            if substring(file-info:file-type,1,1) <> "D" then
                 undo, throw new InvalidPropertyValueError(Name,string(pikey),"Path",pnewvalue).
        end.
        if pNewValue = "" then
           undo, throw new ValidationError("PartitionPolicyField",string(pikey),"Path","cannot be blank. Specify a valid directory name or use period to specify the current directory").

    end method.
    */ 
    method private void ValidateSize(piKey as int,pnewvalue as char).  
        if pnewValue = ? then
            undo, throw new UnknownValueError("Size"). 
        
        if int(pnewvalue) lt 32 then 
            undo, throw new InvalidPropertyValueError(Name,string(pikey),"Size",pnewvalue). 
/*  @todo      Warning: PartitionPolicyField size should be a multiple of 16 database blocks*/
    end method.
    
    method public logical CanFind (PartitionPolicyName as character,Tablename as char,FieldName as char):
        return can-find(ttPartitionPolicyField 
                        where ttPartitionPolicyField.PartitionPolicyName = PartitionPolicyName
                          and ttPartitionPolicyField.TableName = Tablename
                          and ttPartitionPolicyField.FieldName = Fieldname).            
    end method.
      
    method public logical CanFind (pPartitionPolicyName as character, iseq as int ):
        return can-find(ttPartitionPolicyField where ttPartitionPolicyField.PartitionPolicyName = pPartitionPolicyName
                                 and ttPartitionPolicyField.Number = iseq).            
    end method.
    
    method public logical Find (pPartitionPolicyName as character,pTablename as char,pFieldName as char):
        find ttPartitionPolicyField 
                        where ttPartitionPolicyField.PartitionPolicyName = pPartitionPolicyName
                          and ttPartitionPolicyField.TableName = pTablename
                          and ttPartitionPolicyField.FieldName = pFieldname no-error.
        return avail ttPartitionPolicyField.                             
    end method.
        
    method public logical Find (pPartitionPolicyName as character, iseq as int ):
        find  ttPartitionPolicyField where ttPartitionPolicyField.PartitionPolicyName = pPartitionPolicyName
                       and   ttPartitionPolicyField.Number = iseq no-error.
   .
        return avail ttPartitionPolicyField.                          
    end.    
    
    method public logical Delete(pPartitionPolicyName as character,pTablename as char,pFieldName as char):
        define variable l as logical no-undo.
        define variable iSeq as integer no-undo.
        find ttPartitionPolicyField 
                        where ttPartitionPolicyField.PartitionPolicyName = pPartitionPolicyName
                          and ttPartitionPolicyField.TableName = pTablename
                          and ttPartitionPolicyField.FieldName = pFieldname no-error.
        
        if avail ttPartitionPolicyField then
            iSeq = ttPartitionPolicyField.Number. 
        l = Remove().
        if l then
            Resequence(pPartitionPolicyName,iSeq).
        
        return l.                                  
    end method.
    
    method public logical Delete(pPartitionPolicyName as character, iseq as int ):
        define variable l as logical no-undo.
        find ttPartitionPolicyField 
                        where ttPartitionPolicyField.PartitionPolicyName = pPartitionPolicyName
                          and ttPartitionPolicyField.Number = iseq no-error.
        if avail ttPartitionPolicyField then
        do:                  
            l = Remove().
            if l then 
                Resequence(PartitionPolicyName,iSeq).
        end.    
        return l.                                  
    end method.
    
    method void Resequence (pPolicy as char,idel as int):
        define buffer bPartitionPolicyField for ttPartitionPolicyField.
        define variable lTrack as logical no-undo.
        lTrack = temp-table ttPartitionPolicyField:tracking-changes.
        temp-table ttPartitionPolicyField:tracking-changes = false.
       
        for each bPartitionPolicyField where bPartitionPolicyField.PartitionPolicyName = pPolicy
                                         and bPartitionPolicyField.Number >= idel
                                         by bPartitionPolicyField.Number :
            bPartitionPolicyField.Number = Number - 1.                                    
        end.
        temp-table ttPartitionPolicyField:tracking-changes = lTrack.  
    end method.    
    
    method public override logical CanFind(id as integer):
        undo, throw new  UnsupportedOperationError("CanFind of PartitionPolicyField with integer key").        
    end.    
     
    method public override logical CanFind(c as char):
        undo, throw new  UnsupportedOperationError("CanFind of PartitionPolicyField with character key").        
    end.  
     
    method public override logical Find(id as integer):
        undo, throw new  UnsupportedOperationError("Find of PartitionPolicyField with integer key").  
    end.    
    
    method public override logical Find(name as char):
        undo, throw new  UnsupportedOperationError("Find of PartitionPolicyField with character key").        
    end. 
    
    method protected override char FindExpression(i as int):
        return "ttPartitionPolicyField.Number = " + quoter(i).
    end method.
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new PartitionPolicyFieldList(cast(cntxt,PartitionPolicyFieldQuery)). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(pReq as IRequestInfo):
        return new PartitionPolicyField(this-object,preq). 
    end method.
    
    
    method protected override void ValidateBuffer(phDetail as handle):
        define variable hBefore as handle no-undo.
        if phDetail::Number > 15 then
            undo, throw  GetSizeError(phDetail::PartitionPolicyName,phDetail::FieldName).
          
    end method.      
    
    method protected  Error GetSizeError(pmsg as char ):
        define variable cmsg as character no-undo init "The policy cannot have more than 15 fields".
        if pmsg > "" then 
            cmsg = pmsg + ". " + cmsg + ".".
        return new DataContextError(cmsg ) . 
    end method.
    
    method protected  Error GetSizeError(pcdetail as char, pcfield as char ):
         return GetSizeError("Failed to add field " + quoter(pcfield) + " to policy detail "  +  quoter(pcdetail) ) .
    end method.

  
/*    method public void ShowData(pctitle as char):                          */
/*        define variable cc as character no-undo.                           */
/*        for each ttpartitionpolicyfield:                                   */
/*           cc = cc + quoter(recid(ttpartitionpolicyfield))                 */
/*                + " " +  quoter(ttpartitionpolicyfield.Partitionpolicyname)*/
/*                + " " +  quoter(ttpartitionpolicyfield.fieldname)          */
/*                + " " + quoter(ttpartitionpolicyfield.number) + chr(10).   */
/*                                                                           */
/*        end.                                                               */
/*        message cc                                                         */
/*        view-as alert-box title pctitle.                                   */
/*    end method.                                                            */
  
end class.
