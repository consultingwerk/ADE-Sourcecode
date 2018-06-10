/*************************************************************/
/* Copyright (c) 2013,2014 by progress Software Corporation  */
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
   Created     : Aug 2013
   Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IDataTree.
using OpenEdge.DataAdmin.Binding.IJsonRowListener.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IStreamFieldHandler from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.IPartitionPolicyDetail.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.PartitionPolicyDetail.
using OpenEdge.DataAdmin.PartitionPolicyDetailSet.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope from propath.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext from propath.

class OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext inherits DataAdminContext implements IDataAdminContext,IJsonRowListener,IStreamFieldHandler: 
     
    {daschema/partitionpolicydetail.i}
    {daschema/partitionpolicy.i REFERENCE-ONLY}
    
    /* NOTE: needed for tracking changes*/ 
    define private dataset dsPolicyField serialize-name "root" for ttPartitionPolicyDetail.
    define variable SchemaScope as ISchemaScope no-undo.
    define buffer bPartitionPolicyDetail for ttPartitionPolicyDetail. 
    
    define temp-table copytable reference-only like ttPartitionPolicyDetail.  
    
     /* Returns list of fields that need to be exported as separate statements
       This allows the writer to check what to skip from the assign statement 
       (The assumption is that the general assign statement is above the )  */
    define public property StatementFieldNames as character no-undo 
    init "StringValues"
    get.
  
    define public override property TableHandle as handle no-undo 
        get():
            return temp-table ttPartitionPolicyDetail:handle.
        end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "Name". 
        end.    
     
    define public override property Count as integer init ? no-undo  
        get(): 
            if Count = ? then
            do:
                Count = 0.
                for each bPartitionPolicyDetail:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
    
    constructor public PartitionPolicyDetailContext():
        super ("PartitionPolicyDetail").
        ExportWithRoot = false.
    end constructor.
        
    constructor public PartitionPolicyDetailContext (pscope as ISchemaScope):
        super ("PartitionPolicyDetail",pscope).
        SchemaScope = pscope.
        ExportWithRoot = false.
    end constructor.
	
	constructor protected PartitionPolicyDetailContext ( pScope as ISchemaScope,plLocal as log):
        super ("PartitionPolicyDetail",pScope,plLocal).
        SchemaScope = pscope.
        ExportWithRoot = false.
    end constructor.
    
    method override protected void InitChildren ():
        define variable partitionContext as PartitionContext no-undo.
        partitionContext = new PartitionContext().
        AddChild(partitionContext).
    end method.
    
    method override protected void InitChildren (pscope as IContextScope):
        initChildren(cast(pScope,ISchemaScope)).
    end method.
    
    method protected void InitChildren (pscope as ISchemaScope):
        AddChild(pscope:PartitionContext).
    end method.
    
    method public override character GetChildQuery(pparent as IRow).
        define variable cQuery  as character no-undo.  
        define variable iNum as integer no-undo.
        define variable i as integer no-undo.
        define variable cSort as character no-undo.
        define variable cDatatype as character no-undo.
        cQuery  = super:GetChildQuery(pparent).    
        iNum = GetPolicyNumFields(pparent:KeyValue).
        do i = 1 to iNum:
            cDatatype = GetPolicyFieldDataType(pparent:KeyValue,i).
            /* recid is not supported , but we're not dealing with that here  
              - It may be useful that generate data from details can work also with recid */
            if cDatatype = "recid" then
                  cDatatype = "integer". 
        
            cSort = cSort + " by "
                  + if cDatatype = "date" then 
                     ("substr(ttPartitionPolicyDetail.StringValues[" + String(i)  + "],7,4) 
                       + substr(ttPartitionPolicyDetail.StringValues[" + String(i)  + "],1,2) 
                       + substr(ttPartitionPolicyDetail.StringValues[" + String(i)  + "],4,2)") 
                    else 
                         (if cDatatype = "character" then "" else cDatatype + "(")
                          + "ttPartitionPolicyDetail.StringValues[" + String(i)  + "]"
                          + (if cDatatype = "character" then "" else ")").
        
        end.  
         
        return cQuery + if csort = ? then "" else cSort. 
    end method.
    
    method public override character GetJoinFields(parentid as char):
        if parentid = "PartitionPolicies" then 
            return "Name,PartitionPolicyName".
        return "".     
    end.
    
    method public override character GetServerJoinFields(parentid as char):
        if parentid = "PartitionPolicies" then 
            return "ObjectNumber,ObjectNumber".
        return "".     
    end.
    
    /** DataRefreshed from server cannot use copy-temp-table since the primary index
        is on areanumber */
    method private void RefreshTable(input table ttPartitionpolicy):
    /*	    define buffer bPartitionPolicyDetail for ttPartitionPolicyDetail.                                                   */
    /*        define variable lTrack as logical no-undo.                                                                     */
    /*        define variable i as integer no-undo.                                                                          */
    /*        define variable cfieldName as character no-undo.                                                               */
    /*        lTrack = temp-table ttPartitionPolicyDetail:tracking-changes.                                                   */
    /*        temp-table ttPartitionPolicyDetail:tracking-changes = FALSE.                                                    */
    /*                                                                                                                       */
    /*        for each ttPartitionpolicy on error undo, throw:                                                               */
    /*            do i = 1 to extent(ttPartitionpolicy.FieldNames):                                                          */
    /*                cfieldName = ttPartitionpolicy.FieldNames[i].                                                          */
    /*                if cFieldName > "" then                                                                                */
    /*                do:                                                                                                    */
    /*                    find bPartitionPolicyDetail where bPartitionPolicyDetail.PartitionPolicyName = ttPartitionpolicy.Name*/
    /*                                                 and bPartitionPolicyDetail.number              = i no-error.           */
    /*                                                                                                                       */
    /*                    if not avail bPartitionPolicyDetail then                                                            */
    /*                    do:                                                                                                */
    /*                        create bPartitionPolicyDetail.                                                                  */
    /*                        bPartitionPolicyDetail.TableName = ttPartitionpolicy.TableName                                  */
    /*                        bPartitionPolicyDetail.Number = i.                                                              */
    /*                    end.                                                                                               */
    /*                                                                                                                       */
    /*                end.                                                                                                   */
    /*            end.                                                                                                       */
    /*                                                                                                                       */
    /*        end.                                                                                                           */
    /*        finally:                                                                                                       */
    /*            temp-table ttPartitionPolicyDetail:tracking-changes = lTrack.                                               */
    /*        end finally.                                                                                                   */
    end method.
    
    method protected override void CopyTableForParent(piRow as IRow,cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        case piRow:SerializeName:         
            when "partitionPolicies" then 
                do:
                    CopyTable(table-handle hTbl by-reference,piRow).
                end.
            otherwise 
            undo, throw new IllegalArgumentError("PartitionPolicyDetailContext:CopyTableForParent called with parent " + quoter(piRow:SerializeName)).        
        end.
        
        Loaded = false.
    end method.  
    
    method private void CopyTable(input table copytable):
        CopyTable(table copytable by-reference,?).
    end method.
    
    method private void CopyTable(input table copyTable,pRow as IRow):
        define variable dataerror as DataContextError no-undo.      
        define variable lTrack    as logical          no-undo.
        define variable cTable    as character        no-undo.
        define variable iNumFlds  as integer          no-undo.
        define variable i         as integer          no-undo.
        lTrack = temp-table ttPartitionPolicyDetail:tracking-changes.
        
        for each copytable on error undo, throw:  
            do on error undo, throw:
                find bPartitionPolicyDetail where bPartitionPolicyDetail.Name = copytable.Name no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bPartitionPolicyDetail then
                do:
                    create bPartitionPolicyDetail.
                    bPartitionPolicyDetail.Name = copytable.Name .
                end.    
                if valid-object(pRow) then
                do:
                    ctable = pRow:FieldValue("TableName").  
                    if cTable = "" then 
                    do:
                        undo, throw new AppError("Cannot add partition policy detail to a partition policy that does not belong to a table.",?).
                    end.
                    if not int(pRow:FieldValue("NumFields")) > 0 then
                    do:
                        undo, throw new AppError("Cannot add partition policy detail to a partition policy that has no fields.",?).
                    end.                
                end.    
                catch e as Progress.Lang.Error :
                    if avail bPartitionPolicyDetail then delete bPartitionPolicyDetail.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("PartitionPolicyDetail",e).
                    else 
                        dataError:AddMessage(e).                     
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
      
        temp-table ttPartitionPolicyDetail:tracking-changes = true.
        for each copytable:
            create ttPartitionPolicyDetail.    
            buffer-copy copytable to ttPartitionPolicyDetail. 
            if valid-object(pRow)  then 
            do:
                ttPartitionPolicyDetail.PartitionPolicyName = pRow:KeyValue.
                ttPartitionPolicyDetail.TableName = pRow:FieldValue("TableName").
                iNumFlds = int(pRow:FieldValue("NumFields")).
                do i = 1 to iNumFlds :
                    /* in case the values are not assigned yet logical fields need a default that
                       does not blow up when the collection query is opened sorting on the stringvalues 
                       @TODO - using ? as default for StringValues will make this unnecessary  
                               and probably simplify other validation as well 
                               But make sure DataAccess handles it  */
                    if ttPartitionPolicyDetail.StringValues[i] = "" 
                    and GetPolicyFieldDataType(ttPartitionPolicyDetail.PartitionPolicyName,i) = "logical" then
                    do:
                        ttPartitionPolicyDetail.StringValues[i] = "false".
                    end.
                end.
            end.
            Count = Count + 1.
            OnRowCreated().
        end.
        finally:
            temp-table ttPartitionPolicyDetail:tracking-changes = lTrack.
        end finally.
            
    end method.  
    
    method protected override void CopyTable(cntxt as IDataAdminModel ):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.    
 
    method private character GetCreateError(newField as IPartitionPolicyDetail):
        return GetCreateError(newField:Name). 
    end method.
   
    method public override void CreateRow(entity as IDataAdminElement):
        /* if class cast error - the default syserror seems sufficent */
        CreateRow(cast(entity,IField)).    
    end method.
	
    method public void CreateRow(policyDetail as IPartitionPolicyDetail):
        define variable validateError as DataContextError no-undo.
        define variable ltrack        as logical          no-undo.
        lTrack = temp-table ttPartitionPolicyDetail:tracking-changes .
        temp-table ttPartitionPolicyDetail:tracking-changes = true.
        /*        ValidateDomain(policyDetail).*/
        
        do on error undo, throw: 
            Count = Count + 1.
            create ttPartitionPolicyDetail.
            assign 
                ttPartitionPolicyDetail.Name          = policyDetail:name
                ttPartitionPolicyDetail.Description   = policyDetail:Description  
                ttPartitionPolicyDetail.IsDataEnabled = policyDetail:IsDataEnabled
                ttPartitionPolicyDetail.IsReadOnly    = policyDetail:IsReadOnly
                ttPartitionPolicyDetail.IsSplitTarget = policyDetail:IsSplitTarget
                ttPartitionPolicyDetail.IsAllocated   = policyDetail:IsAllocated.
            if valid-object(policyDetail:DefaultDataArea) then
                ttPartitionPolicyDetail.DefaultDataAreaName  = policyDetail:DefaultDataArea:Name.
            if valid-object(policyDetail:DefaultIndexArea) then
                ttPartitionPolicyDetail.DefaultIndexAreaName = policyDetail:DefaultIndexArea:Name.
            if valid-object(policyDetail:DefaultLobArea) then
                ttPartitionPolicyDetail.DefaultLobAreaName   = policyDetail:DefaultLobArea:Name.
            ttPartitionPolicyDetail.DefaultAllocation    = policyDetail:DefaultAllocation.
            Count = Count + 1.
            OnRowCreated().      
            catch e as Error:  
                delete ttPartitionPolicyDetail.
                undo, throw new DataContextError(GetCreateError(policyDetail),Name,e).  
            end catch.  
        end.
        finally:
            temp-table ttPartitionPolicyDetail:tracking-changes = ltrack.               
        end finally.
    end method.
    
    method public void UpdateValue(pcOldname as char, pcNewname as char):
    end.
    
    /** read a buffer field from json  */
    method protected override void ReadField(pjson as JsonObject,phfld as handle):
        define variable cField    as character  no-undo.
        define variable cDataType as character  no-undo.
        define variable hBuffer   as handle     no-undo.
        define variable cname     as character  no-undo.
        define variable i         as integer    no-undo.
        define variable inum      as integer    no-undo.
        define variable iFldnum   as integer    no-undo.
        define variable cfldname  as character  no-undo.
        define variable cVal      as character  no-undo.
        define variable jsonArray as JsonArray  no-undo.
        define variable json      as JsonObject no-undo.
        define variable cMsg      as character  no-undo.
        define variable cExpected as character  no-undo.
        define variable cReal     as character  no-undo.
        define variable cTable    as character  no-undo.
        define variable dval      as decimal no-undo.
        if phFld:name = "StringValues" then
        do:
            hBuffer = TableHandle:default-buffer-handle. 
            if SchemaScope:PartitionPolicyContext:Find(hBuffer::PartitionPolicyName) then
            do:
                jsonArray = pjson:GetJsonArray("values").
                inum = GetPolicyNumFields(hBuffer::PartitionPolicyName).
                if inum = ? then
                    undo, throw new IllegalArgumentError("PartitionPolicy " + quoter(hBuffer::PartitionPolicyName) + " not found.").
      
                if inum = 0 then
                    undo, throw new IllegalArgumentError("PartitionPolicy " + quoter(hBuffer::PartitionPolicyName)  + " has no fields defined.").
      
                if inum <> jsonArray:Length then 
                do:
                    cMsg = "The policy has " + string(inum) + " &1" +
                        " but the json file has " + string(jsonArray:Length) + " &2". 
                    if inum = 1 then
                        cExpected = "column". 
                    else
                        cExpected = "columns".
                   
                    if jsonArray:Length = 1 then
                        cReal = "value". 
                    else
                        cReal = "values".
                       
                    undo, throw new IllegalArgumentError(substitute(cMsg,cExpected,cReal)).
                end.  
            end.
            else 
            do:
                /* cannot support import of new because we do not know the parent 
                   - we could  support character values for all values 
                               and validate in stringvalues in context:copy   */
                undo, throw new UnsupportedOperationError("Import of partition policy detail values from json to new collection without policy parent.").
            /*     inum = jsonArray:Length.*/
            end.    
            cName = "value". 
            do i = 1 to inum on error undo,leave:
                json  = jsonArray:GetJsonObject(i).
                cfldname = json:GetCharacter("fieldName").
                cTable =  GetPolicyTableName(hBuffer::PartitionPolicyName).
                iFldnum = GetPolicyFieldNumber(hBuffer::PartitionPolicyName,cTable,cfldname ).
                if iFldnum = 0 then 
                    undo, throw new IllegalArgumentError("Json fieldName " + cfldname + " is not defined for the policy.").
                cDataType = GetPolicyFieldDataType(hBuffer::PartitionPolicyName,iFldnum).
                case cDataType:
                    when "int64" then
                    do on error undo,leave: 
                        cVal = string(json:GetInt64(cname)).
                        catch e as Progress.Lang.Error :
                            dval = ?.
                            dval = json:GetDecimal(cname) no-error.
                            if error-status:error then
                            do:
                                cVal = json:GetCharacter(cname).
                                CheckValue(cval,"int64").
                            end. 
                            else do:
                                undo, throw new AppError(" Invalid character in int64 input " + string(dval) + "." ,?).  
                            end.  
                        end catch.
                    end.
                    when "integer" then
                    do on error undo,leave: 
                        cVal = string(json:GetInteger(cname)).
                        catch e as Progress.Lang.Error :
                            dval = ?.
                            dval = json:GetDecimal(cname) no-error.
                            if error-status:error then
                            do:
                                cVal = json:GetCharacter(cname).
                                CheckValue(cval,"integer").
                            end. 
                            else do:
                                undo, throw new AppError(" Invalid character in integer input " + string(dval) + "." ,?).  
                            end.  
                        end catch.
                    end.
                    when "character" then
                        cVal = json:GetCharacter(cname).
                    when "logical" then
                    do on error undo,leave: 
                        cVal = string(json:GetLogical(cname)).
                        catch e as Progress.Lang.Error :
                            cVal = json:GetCharacter(cname).
                            CheckValue(cval,"logical").
                        end catch.
                    end.
                    when "date" then
                        cVal = AmericanDateString(json:GetDate(cname)).
                    when "datetime" then
                        cVal = string(json:GetDatetime(cname)).
                    when "datetime-tz" then
                        cVal = string(json:GetDatetimeTZ(cname)).
                    when "decimal" then
                    do on error undo,leave: 
                        cVal = AmericanNumericString(json:GetDecimal(cname)).
                        catch e as Progress.Lang.Error :
                            cVal = json:GetCharacter(cname).
                            CheckValue(cval,"decimal").
                        end catch.
                    end.   
                end case.
                phfld:buffer-value (iFldnum) = cval.
                catch e as Progress.Lang.Error :
                    define variable cErrmsg as character no-undo.
                    define variable e2 as AppError no-undo.
                    define variable lmsgdone as logical no-undo.
                    cErrMsg = "Cannot read value for " + cfldname + ".". 
                    if e:GetMessageNum(1) = 76 then
                       assign
                          lmsgdone = true.
                          cErrMsg = cErrMsg + " " + replace(replace(trim(e:GetMessage(1)),"**",""),"(76)","").
                    e2 = new AppError(cErrMsg,?).
                    if not lmsgdone then
                        e2:AddMessage(e:GetMessage(1),?).
                    undo, throw e2.    
                end catch.
            end.     
        end. /* phFld:name = "StringValues" */
        else 
            super:ReadField(pjson,phfld).    
    end.
    
    method public char GetAmericanValue(pcPolicyName as char,pctype as char,pVal as char,i as int):
        define variable ctype as character no-undo.
        AssertScope( ).
        cType = GetPolicyFieldDataType(pcPolicyName,i).
        if cType <> pctype then
        do on error undo, throw: 
            CheckValue(string(pval),cType).
            catch e as Progress.Lang.Error :
                undo, throw new IllegalArgumentError("Cannot assign value for field number "  + String(i) 
                    +  " field " + quoter(GetPolicyFieldName(pcPolicyName,i)) + ". "
                    + pval + " is not a valid " + cType + "."
                    ,e). 
            end catch.
        end.    
        if cType = "decimal" then 
        do:
            return AmericanNumericString(dec(pVal)).
        end.
        else if cType = "date" then
            return AmericanDateString(date(pval)).
        return pval.    
    end.
    
    method private char AmericanNumericString (pval as dec):
        define variable cSep as char      no-undo. 
        define variable cdec as char      no-undo.
        define variable cVal as character no-undo.
        cdec = session:numeric-decimal-point.
        csep = session:numeric-separator.
        session:numeric-format = "american".
        return string(pval).
        finally:
            session:set-numeric-format (csep,cdec). 
        end finally.  
    end.     
    
    method  private char AmericanDateString(val as date ):
        define variable cdat as char      no-undo. 
        define variable cVal as character no-undo.
        cdat = session:date-format.
        session:date-format = "mdy".
        return string(val,"99/99/9999").
        finally:
            session:date-format = cdat. 
        end finally.  
    end.   
    
    method  private date DateFromAmerican(pval as char ):
        define variable cdat as char no-undo. 
        define variable ioff as int  no-undo. 
        define variable da   as date no-undo.
        cdat = session:date-format.
        ioff = session:year-offset.
        session:date-format = "mdy".
        session:year-offset = 1950.
        da = date(pval).
        return da.
        finally:
            session:date-format = cdat. 
            session:year-offset = ioff. 
        end finally.  
    end.   
    
    method  private decimal DecimalFromAmerican(pval as char ):
        define variable cSep as char      no-undo. 
        define variable cdec as char      no-undo.
        define variable cVal as character no-undo.
        define variable dval as decimal   no-undo.
        cdec = session:numeric-decimal-point.
        csep = session:numeric-separator.
        session:numeric-format = "american".
        dval = dec(pval).
        return dval.
        finally:
            session:set-numeric-format (csep,cdec). 
        end finally.  
    end.   
    
    method public void AssertScope( ):
        define variable cType as character no-undo.
        if not valid-object(SchemaScope) then
            undo, throw new IllegalOperationError("Cannot update value for a  partition policy detail that does not belong to a partition policy."). 
    end.
    
    method private logical CheckValue(val as char, dt as char ):
        case dt:
            when "" or 
            when ? then
                return false.
            when "logical" then
                logical(val).
            when "integer" then
                int(val).
            when "int64" then
                int64(val).
            when "decimal" then
                decimal(val).
            when "date" then
                date(val).
            when "datetime" then
                datetime(val).
            when "datetime-tz" then
                datetime-tz(val).
        end.
        return true.
        catch e as Progress.Lang.Error :
            /*        	return false.	*/
            undo, throw e.
        end catch.
    end.    
    
    method public char GetPolicyTableName(pcPolicyName as char):
        if not valid-object(SchemaScope) then
            return ?. 
        return  SchemaScope:PartitionPolicyContext:FetchTableName(pcPolicyName).
    end.
    
    
    method public int GetPolicyNumFields(pcPolicyName as char):
        if not valid-object(SchemaScope) then
            return ?. 
        return SchemaScope:PartitionPolicyContext:FetchNumFields(pcPolicyName).   
    end.
        
    method public int GetPolicyFieldNumber(pcPolicyName as char, pcTable as char, pcfield as char):
        return SchemaScope:PartitionPolicyFieldContext:FetchFieldNumber(pcPolicyName,pcTable,pcfield).
    end.
    
    method public char GetPolicyFieldDataType(pcPolicyName as char,  pinum as int):
        return SchemaScope:PartitionPolicyFieldContext:FetchField(pcPolicyName,pinum,"dataType") .
    end.
    
    method public char GetPolicyFieldName(pcPolicyName as char,  pinum as int):
        return SchemaScope:PartitionPolicyFieldContext:FetchField(pcPolicyName,pinum,"fieldName") .
    end.
    
/*    method protected IFetchRequest GetNewRequest(pcPolicyname as char) :                                          */
/*        define variable req as IFetchRequest no-undo.                                                             */
/*        define variable h as handle no-undo.                                                                      */
/*        define variable cflds as character extent no-undo.                                                        */
/*        define variable i as integer no-undo.                                                                     */
/*        define variable cquery as character no-undo.                                                              */
/*        h = CreateServerDataset().                                                                                */
/*        req = new FetchRequest(this-object:Name,Id,h,no).                                                         */
/*        cQuery = "where ttPartitionPolicy.Name = " +  quoter(pcPolicyname)                                        */
/*               + " and  ttPartitionPolicy.TableName = " + quoter(GetPolicyTableName(pcPolicyname))                */
/*               + " and  ttPartitionPolicy.HasRange = "  + quoter(plrange).                                        */
/*        cflds = SchemaScope:PartitionPolicyFieldContext:GetFieldNames(pcPolicyname).                              */
/*                                                                                                                  */
/*        do i = 1 to extent(cflds):                                                                                */
/*             cQuery = " and ttPartitionPolicyField.FieldName = " +  quoter(cflds[i]) .                            */
/*        end.                                                                                                      */
/*        req:SetTableRequestType("ttPartitionPolicyDetail","NEW").                                                 */
/*        /* somewhat hacky                                                                                         */
/*        - the query is used to pass request parameters. Taking advantage of the existing query passing and parsing*/
/*          mechanisms. It is not used as a query on the server (the fields may not exist in the tt) .  */          */
/*                                                                                                                  */
/*        req:SetTableQuery("ttPartitionPolicy",cQuery).                                                            */
/*        return req.                                                                                               */
/*    end method.                                                                                                   */
    
/*    method public void FetchNewData(pcName as char,plrange as log,idx as IIndex):                    */
/*        FetchData(getNewRequest(pcName,plRange,idx,0)).                                              */
/*    end method.                                                                                      */
/*                                                                                                     */
/*    method public void FetchNewData(pcName as char,plrange as log,idx as IIndex, pinumfields as int):*/
/*        FetchData(getNewRequest(pcName,plRange,idx,pinumfields)).                                    */
/*    end method.                                                                                      */
    
    method public void UpdatePartitionDefault(pcPolicyName as char, pcfield as char, pcold as char, pcnew as char):
        define variable partitionContext as PartitionContext no-undo.                                    
        define variable lTrack as logical no-undo.
        if pcfield = "DefaultAllocation" then 
        do:
            partitionContext = cast(getChild("partitions"),PartitionContext).
            for each ttPartitionPolicyDetail where ttPartitionPolicyDetail.PartitionPolicyName = pcPolicyName:
                partitionContext:UpdatePolicyDetailDefault(ttPartitionPolicyDetail.name,pcfield,pcold,pcnew). 
            end.
        end.
        else do on error undo, throw:
            lTrack = temp-table ttPartitionPolicyDetail:tracking-changes.
            temp-table ttPartitionPolicyDetail:tracking-changes = true.
            for each ttPartitionPolicyDetail where ttPartitionPolicyDetail.PartitionPolicyName = pcPolicyName:
                case pcField:
                    when "DefaultDataArea" then 
                    do:
                        if ttPartitionPolicyDetail.DefaultDataAreaName = pcold then
                        do:
                            ttPartitionPolicyDetail.DefaultDataAreaName = pcnew.
                            ValueChanged(pcField,pcold,pcnew). 
                        end.    
                    end.
                    when "DefaultIndexArea" then 
                    do:
                        if ttPartitionPolicyDetail.DefaultIndexAreaName = pcold then
                        do:
                            ttPartitionPolicyDetail.DefaultIndexAreaName = pcnew.
                            ValueChanged(pcField,pcold,pcnew). 
                        end.    
                    end.
                    when "DefaultLobArea" then 
                    do:
                        if ttPartitionPolicyDetail.DefaultLobAreaName = pcold then
                        do:
                            ttPartitionPolicyDetail.DefaultLobAreaName = pcnew.
                            ValueChanged(pcField,pcold,pcnew). 
                        end.    
                    end.                
                end.    
            end.    
            finally:
                temp-table ttPartitionPolicyDetail:tracking-changes = lTrack.
            end finally.  
        end.
    end method.    
    
    /** fires after change - validation should have been done */
    method protected override void ValueChanged(pFieldName as char,pcOldValue as char,pNewValue as char).        
        define variable partitionContext as PartitionContext no-undo.                                    
        super:ValueChanged(pfieldname,pcoldvalue,pNewValue).
        /* if new policy then the partitions must be updated with default values */
        if pFieldName begins "Default" 
        and (buffer ttPartitionPolicyDetail:row-state = row-created 
             /* rootid = rowid implies new tenant */
             or RootId = rowid(ttPartitionPolicyDetail) ) then
        do: 
            partitionContext = cast(getChild("Partitions"),PartitionContext).
            partitionContext:UpdatePolicyDetailDefault(ttPartitionPolicyDetail.name,pFieldName,pcOldValue,pNewValue).
        end.
    end method.
    method public void UpdatePartitionPolicyName(pcOldname as char, pcNewname as char):
        define variable lTrack as logical no-undo.
        define buffer bPartitionPolicyDetail for ttPartitionPolicyDetail.
        lTrack = temp-table ttPartitionPolicyDetail:tracking-changes.
        temp-table ttPartitionPolicyDetail:tracking-changes = false.
        for each bPartitionPolicyDetail where bPartitionPolicyDetail.PartitionPolicyName = pcOldname:
            assign 
                bPartitionPolicyDetail.PartitionPolicyName = pcNewname.
        end.    
        finally:
            temp-table ttPartitionPolicyDetail:tracking-changes = lTrack.
        end.
    end. 
    
    method public override void SerializeRow(phStream as handle):
        export stream-handle phStream
            ttPartitionPolicyDetail.Name
            ttPartitionPolicyDetail.PartitionPolicyName
            ttPartitionPolicyDetail.StringValues
            ttPartitionPolicyDetail.Description
            ttPartitionPolicyDetail.DefaultDataAreaName
            ttPartitionPolicyDetail.DefaultIndexAreaName 
            ttPartitionPolicyDetail.DefaultLobAreaName
            ttPartitionPolicyDetail.IsReadOnly
            /*  not in db          ttPartitionPolicyDetail.DefaultAllocation*/
          
            /*** end 11.4 **/   
            .
    end method. 
    
    method protected override logical DeserializeRow(phStream as handle, plReplace as log):
        define variable lok                   as logical no-undo.
        define variable tname                 like ttPartitionPolicyDetail.Name no-undo.
        define variable tPartitionPolicyName  like ttPartitionPolicyDetail.PartitionPolicyName no-undo.
        define variable tStringValues         like ttPartitionPolicyDetail.StringValues no-undo.
        define variable tDescription          like ttPartitionPolicyDetail.Description no-undo.
        define variable tDefaultDataAreaName  like ttPartitionPolicyDetail.DefaultDataAreaName no-undo.
        define variable tDefaultIndexAreaName like ttPartitionPolicyDetail.DefaultIndexAreaName no-undo.
        define variable tDefaultLobAreaName   like ttPartitionPolicyDetail.DefaultLobAreaName no-undo.
        define variable tDefaultAllocation    like ttPartitionPolicyDetail.DefaultAllocation no-undo.
        define variable tIsReadOnly           like ttPartitionPolicyDetail.IsReadOnly no-undo.
        define variable lnew                  as logical no-undo. 
        do on endkey undo, leave:
            import stream-handle phStream
                tName
                tPartitionPolicyName
                tStringValues
                tDescription
                tDefaultDataAreaName
                tDefaultIndexAreaName
                tDefaultLobAreaName
                tisReadOnly
                /*      not in db        tDefaultAllocation*/
            
                .
            if plReplace then
            do: 
                find ttPartitionPolicyDetail where ttPartitionPolicyDetail.name = tname no-error.
            end.
            
            if not plReplace or not avail ttPartitionPolicyDetail then 
            do:
                create ttPartitionPolicyDetail. 
                lnew = true.
            end.        
            assign 
                ttPartitionPolicyDetail.Name                 = tName
                ttPartitionPolicyDetail.PartitionPolicyName  = tPartitionPolicyName
                ttPartitionPolicyDetail.StringValues         = tStringValues
                ttPartitionPolicyDetail.Description          = tDescription
                ttPartitionPolicyDetail.DefaultDataAreaName  = tDefaultDataAreaName 
                ttPartitionPolicyDetail.DefaultIndexAreaName = tDefaultIndexAreaName 
                ttPartitionPolicyDetail.DefaultLobAreaName   = tDefaultLobAreaName 
                /*              ttPartitionPolicyDetail.DefaultAllocation = tDefaultAllocation*/
                ttPartitionPolicyDetail.IsReadOnly        = tisReadOnly
                .
            lok = true.    
          
            catch e as Progress.Lang.Error :
                undo, throw e.
            end catch. 
        end.
        if not lok then   
        do:
            if avail ttPartitionPolicyDetail and lnew then
                delete ttPartitionPolicyDetail.
        end.    
        else if lok and lnew then     
            do: 
                Count = Count + 1.
                OnRowCreated().
            end.        
        return lok.
        catch e as Progress.Lang.Error :
            if avail ttPartitionPolicyDetail and lnew then
                delete ttPartitionPolicyDetail.
            undo, throw e.
        end catch.    
    end method. 
    
    method public void CreateRow(pcPolicyName as char,pname as char):
        define variable validateError as DataContextError no-undo.
        define variable lTrack        as logical          no-undo.
        lTrack = temp-table ttPartitionPolicyDetail:tracking-changes.
        temp-table ttPartitionPolicyDetail:tracking-changes = true.
        /*        ValidateArea(area).*/
        
        do on error undo, throw: 
            create ttPartitionPolicyDetail.
            assign 
                ttPartitionPolicyDetail.PartitionPolicyName = pcPolicyName
                ttPartitionPolicyDetail.Name                = pname .
            Count = Count + 1.
            OnRowCreated().        
            catch e as Error:  
                delete ttPartitionPolicyDetail.
                undo, throw new DataContextError(GetCreateError(name),"PartitionPolicyDetail",e).  
            end catch.  
        
        end.
        finally:
            temp-table ttPartitionPolicyDetail:tracking-changes = lTrack.
        end.
    end method.
    
    /*     /** override to validate path and size */                                                                              */
    /*    method protected override void ValidateProperty(pcfield as char,poldvalue as char,pnewvalue as char).                   */
    /*        if valid-object(Service) then                                                                                       */
    /*            undo, throw new CreateOnlyPropertyError("PartitionPolicyField",string(ttPartitionPolicyDetail.number),pnewValue).*/
    /*        super:ValidateProperty(pcField,poldvalue,pnewvalue).                                                                */
    /*        case pcfield:                                                                                                       */
    /*/*            when "Path" then                            */                                                                */
    /*/*                ValidatePath(ttPartitionPolicyDetail.Number,pnewvalue).*/                                                  */
    /*            when "Size" then                                                                                                */
    /*                ValidateSize(ttPartitionPolicyDetail.Number,pnewvalue).                                                      */
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
    method public override void SetTreeOptions(tree as IDataTree).
        super:SetTreeOptions(tree).
        if tree:Write then
        do:
            tree:UseDataset = false.
            tree:AddRowListener(this-object).
        end. 
        if tree:WriteCode then 
        do:
            tree:SetFieldHandler(SerializeName,this-object).
        end.     
    end method. 
    
 
    /* IStreamFieldHandler writes field assignments - returns list of field exported so the generator knows what to skip
     . returns blank if no fields written - */  
    method public char WriteFieldAssignments(phstream as handle,pcvarname as char,piAt as int, phbuf as handle):
        return "".
   end method. 
   
    /* IStreamFieldHandler writes field assign statements for cases that cannot be used in assign 
     - StatementFieldNames must return the corresponding list  */ 
    method public void WriteFieldStatements(phstream as handle,pcvarname as char,phbuf as handle).
         define variable htbl as handle no-undo.
         define variable rid as recid no-undo.
         rid = phbuf:recid.
         htbl = phbuf:table-handle.
         WriteValuesAsCode(phStream,pcvarname,rid,table-handle htbl by-reference).
    end method. 
    
     /* genereate code for value assignment */
    method private void WriteValuesAsCode(phStream as handle,pcinstName as char,prec as recid,table ttPartitionPolicyDetail):
        define variable i         as integer    no-undo.
        define variable iNumFlds  as integer    no-undo.
        define variable ctype     as character no-undo.
        define variable cfld as character no-undo.
        define variable cvaltxt as character no-undo.
        define variable cvalue as character no-undo.
        define variable ddat as date no-undo.
        find ttPartitionPolicyDetail where recid(ttPartitionPolicyDetail) = prec.
     
        iNumFlds = GetPolicyNumFields(ttPartitionPolicyDetail.PartitionPolicyName).
        cvaltxt = if iNumFlds = 1 then "value" else "values".
        put stream-handle phStream    unformatted skip
               "/* Set the " + cvaltxt + " for the policy detail */" skip.
          
        do i = 1 to iNumFlds:
            ctype = GetPolicyFieldDataType(ttPartitionPolicyDetail.PartitionPolicyName,i).
            cfld = GetPolicyFieldName(ttPartitionPolicyDetail.PartitionPolicyName,i).
            put stream-handle phStream unformatted 
                 pcinstName ":SetValue(" .
            case ctype:
                when "character" then
                do:  
                    cvalue = quoter(ttPartitionPolicyDetail.StringValues[i]).
                end.
                when "decimal" then
                do:  
                    cvalue =  ttPartitionPolicyDetail.StringValues[i] .
                    if index(cvalue,".")  = 0 then
                       cvalue = cvalue  + ".0" .
                    
                end.
                when "date" then
                do:
                    /* force 4 digit year.. */
                    ddat = DateFromAmerican(ttPartitionPolicyDetail.StringValues[i]).
                    cvalue = AmericanDateString(ddat).
                end.  
                when "datetime"  or when "datetime-tz"  then
                do:
                    cvalue = lc(ctype) + "(" + quoter(ttPartitionPolicyDetail.StringValues[i])  + ")".
                end. 
                when "int64" then
                do:
                    cvalue = lc(ctype) + "(" +  ttPartitionPolicyDetail.StringValues[i]   + ")".
                end. 
                otherwise 
                do:  
                    cvalue = ttPartitionPolicyDetail.StringValues[i].
                end.
            end. 
            
            put stream-handle phStream unformatted 
                cvalue.
                
            if iNumFlds > 1 then 
                 put stream-handle phStream unformatted "," i.
            put stream-handle phStream unformatted 
                  "). /* " + cfld " as "  + ctype +  " */ " skip .
        end.
        
        
    end method.    
    
    method public void AddRowValues(pname as char,pjson as JsonObject,table-handle h):
        if pname = "partitionPolicyDetails" then
        do:
            AddDetailValues(pjson,table-handle h by-reference).
        end.    
    end method. 
    
    method public void AddDetailValues(pjson as JsonObject,table ttPartitionPolicyDetail):
        define variable i         as integer    no-undo.
        define variable iNumFlds  as integer    no-undo.
        define variable ctype     as character  no-undo.
        define variable cvaltxt   as character  no-undo init "value".
        define variable jsonarray as JsonArray  no-undo.
        define variable jsonRow   as JsonObject no-undo.
       
        find ttPartitionPolicyDetail where ttPartitionPolicyDetail.Name = pjson:GetCharacter("name").
        if pjson:Has("values") then
            pjson:Remove("values").
        jsonarray = new  JsonArray().    
        pjson:Add("values",jsonarray).
        iNumFlds = GetPolicyNumFields(ttPartitionPolicyDetail.PartitionPolicyName).
        do i = 1 to iNumFlds:
            jsonRow = new  JsonObject().
            jsonarray:Add(jsonRow).
            jsonRow:Add("fieldName",GetPolicyFieldName(ttPartitionPolicyDetail.PartitionPolicyName,i)).
            ctype = GetPolicyFieldDataType(ttPartitionPolicyDetail.PartitionPolicyName,i).
            case ctype:
                when "character" then
                    do:  
                        jsonRow:Add(cvaltxt,ttPartitionPolicyDetail.StringValues[i]).
                    end.
                when "decimal" then
                    do:  
                        jsonRow:Add(cvaltxt,DecimalFromAmerican(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "logical" then
                    do:  
                        jsonRow:Add(cvaltxt,logical(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "integer" then
                    do:
                        jsonRow:Add(cvaltxt,int(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "int64" then
                    do:  
                        jsonRow:Add(cvaltxt,int64(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "date" then
                    do:  
                        jsonRow:Add(cvaltxt,DateFromAmerican(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "datetime" then
                    do:  
                        jsonRow:Add(cvaltxt,datetime(ttPartitionPolicyDetail.StringValues[i])).
                    end.
                when "datetime-tz" then
                    do:  
                        jsonRow:Add(cvaltxt,datetime-tz(ttPartitionPolicyDetail.StringValues[i])).
                    end. 
            end.    
        end.    
    end method.
    
        
    method public override logical CanFind (pName as char):
        return can-find(ttPartitionPolicyDetail where  ttPartitionPolicyDetail.Name = pName ).            
    end method.
      
    method public override logical Find (pName as character):
        find ttPartitionPolicyDetail where ttPartitionPolicyDetail.Name = pname  no-error.
        return avail ttPartitionPolicyDetail.                             
    end method.
        
    method public override logical Delete(pName as char):
        find ttPartitionPolicyDetail where ttPartitionPolicyDetail.Name = pname  no-error.
        if avail ttPartitionPolicyDetail then
            return Remove().
        return false.                                  
    end method.
    
    method public override logical CanFind(pid as integer):
        return can-find(ttPartitionPolicyDetail where  ttPartitionPolicyDetail.id = pid ).       
    end.    
     
    method public override logical Find(pid as integer):
        find ttPartitionPolicyDetail where ttPartitionPolicyDetail.id = pid  no-error.
        return avail ttPartitionPolicyDetail.                             
    end.    
    
    method protected override char FindExpression(pid as int):
        return "ttPartitionPolicyDetail.Id = " + quoter(pid).
    end method.
    
    method public override character ColumnSource(pcColumn as char):
        if pcColumn = "PartitionPolicyType" then
            pcColumn = "PartitionPolicy.Type".
        else if pcColumn begins "Values[" then
            pcColumn = replace (pcColumn,"Values","StringValues").
        return super:ColumnSource(pcColumn).
    end.    
   
    /*    method override protected FilteredContext CreateFilteredContext(pparent as char,pkey as char,pReq as IRequestInfo):*/
    /*         case pparent:                                                                                                 */
    /*/*             when "areas" then                                     */                                                */
    /*/*             do:                                                   */                                                */
    /*/*                 return new AreaPartitionPolicyFieldQuery(this-object,pkey,pReq).*/                                                */
    /*/*             end.                                                  */                                                */
    /*        otherwise                                                                                                      */
    /*                 return super:CreateFilteredContext(pparent,pkey,pReq).                                                */
    /*         end.                                                                                                          */
    /*    end method.                                                                                                        */

    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new PartitionPolicyDetailSet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        return new PartitionPolicyDetail(this-object,preq). 
    end method.
    
/*    method override public void DataRefreshed(presponse as IFetchResponse):   */
/*        super:DataRefreshed(presponse).                                       */
/*        define variable cc as character no-undo.                              */
/*        define variable i as integer no-undo.                                 */
/*          for each ttPartitionPolicyDetail by  InternalSort desc:             */
/*               cc = cc                                                        */
/*               + ttPartitionPolicyDetail.PartitionPolicyName                  */
/*               + " "  + quoter(ttPartitionPolicyDetail.name)                  */
/*               + " "  + quoter(ttPartitionPolicyDetail.sTRINGvALUES[1])       */
/*               + " "  + quoter(ttPartitionPolicyDetail.sTRINGvALUES[2])       */
/*               + " "  + quoter(ttPartitionPolicyDetail.sTRINGvALUES[3])       */
/*               + " " + string(ttPartitionPolicyDetail.InternalSort) + chr(10).*/
/*                   i = i  + 1.                                                */
/*               if length(cc) > 15000 then leave.                              */
/*          end.                                                                */
/*          message cc i                                                        */
/*          view-as alert-box.                                                  */
/*    end method.                                                               */

/*/*    /** override to deal with unique key on number */                                    */*/
/*    method public override void DataRefreshed(pResponse as IFetchResponse):                  */
/*        define variable hNewBuffer as handle no-undo.                                        */
/*        define variable hTable as handle no-undo.                                            */
/*        if  pResponse:EntityName = "PartitionPolicy" then                                    */
/*        do:                                                                                  */
/*            hNewBuffer = pResponse:DataHandle:get-buffer-handle("ttPartitionPolicyDetail").   */
/*            hTable = hNewBuffer:table-handle.                                                */
/*           message hTable:has-records                                                        */
/*           view-as alert-box.                                                                */
/*        end.                                                                                 */
/*         super:DataRefreshed(pResponse).                                                     */
/*    end method.                                                                              */
    
        
end class.
