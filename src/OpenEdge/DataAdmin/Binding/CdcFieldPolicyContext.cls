 /*************************************************************/
 /* Copyright (c) 2015-2018 by Progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 
 /*------------------------------------------------------------------------
    File        : CdcFieldPolicyContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Tue Nov 24 15:18:14 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IJsonRowListener.
using OpenEdge.DataAdmin.Binding.IStreamFieldHandler.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IDataTree.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.IStreamFieldHandler from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.IFieldList.
using OpenEdge.DataAdmin.IIndex.
using OpenEdge.DataAdmin.ICdcFieldPolicy.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.CdcFieldPolicy.
using OpenEdge.DataAdmin.CdcFieldPolicySet.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Error. 
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.

block-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext inherits DataAdminContext implements IDataAdminContext, IJsonRowListener, IStreamFieldHandler:
    
    {daschema/cdcfieldpolicy.i}
    {daschema/cdctablepolicy.i REFERENCE-ONLY}
    
    /* NOTE: needed for tracking changes*/ 
    define private dataset dsPolicyField serialize-name "root" for ttCdcFieldPolicy.
    define variable SchemaScope as ISchemaScope no-undo.
    define buffer bCdcFieldPolicy for ttCdcFieldPolicy. 
    
    define temp-table copytable reference-only like ttCdcFieldPolicy.     

	define override public property Count as integer init ? no-undo 
	get(): 
            if Count = ? then
            do:
                Count = 0.
                for each bCdcFieldPolicy:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set. 

	define override public property KeyFields as character no-undo 
	get():
            return "FieldName". 
        end. 

	define public property StatementFieldNames as character no-undo 
	init "StringValues"
	get.	

	define override public property TableHandle as handle no-undo 
	get():
            return temp-table ttCdcFieldPolicy:handle.
        end get. 
        
    constructor public CdcFieldPolicyContext():
        super ("CdcFieldPolicy").
        ExportWithRoot = false.
    end constructor.
        
    constructor public CdcFieldPolicyContext (pscope as ISchemaScope):
        super ("CdcFieldPolicy",pscope).
        SchemaScope = pscope.
        ExportWithRoot = false.
    end constructor.
    
    constructor protected CdcFieldPolicyContext ( pScope as ISchemaScope,plLocal as log):
        super ("CdcFieldPolicy",pScope,plLocal).
        SchemaScope = pscope.
        ExportWithRoot = false.
    end constructor.
    
    method public override character GetChildQuery(pparent as IRow).
        define variable cQuery  as character no-undo.
        define variable cSort as character no-undo.
        //message "GetChildQuery from FPContext" view-as alert-box.
        cQuery  = super:GetChildQuery(pparent).         
        return cQuery + cSort. 
    end method.
    
    method protected override void CopyTableForParent(piRow as IRow,cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        case piRow:SerializeName:         
            when "cdcTablePolicies" then 
                do:
                    CopyTable(table-handle hTbl by-reference,piRow).
                end.
            otherwise 
            undo, throw new IllegalArgumentError("CdcFieldPolicyContext:CopyTableForParent called with parent " + quoter(piRow:SerializeName)).        
        end.
        
        Loaded = false.
    end method.

	method public void AddRowValues( input pname as character, input pjson as JsonObject, input TABLE-HANDLE h ):
		if pname = "cdcFieldPolicies" then
        do:
            AddFieldPolicyValues(pjson,table-handle h by-reference).
        end.
	end method.
	
	method public void AddFieldPolicyValues(pjson as JsonObject,table ttCdcFieldPolicy):
        define variable fldName   as character  no-undo.
        
        if pjson:has("fieldName") then do:
            if num-entries (pjson:GetCharacter("fieldName"),"@") > 1 then
                fldName = entry(1,pjson:GetCharacter("fieldName"),"@").
            else fldName = pjson:GetCharacter("fieldName").
            pjson:set("fieldName",fldName).
        end.                            
        //if pjson:Has("values") then
        //    pjson:Remove("values").
        //jsonarray = new  JsonArray().    
        //pjson:Add("values",jsonarray).
        /*iNumFlds = GetPolicyNumFields(ttCdcFieldPolicy.CdcTablePolicyName).
        do i = 1 to iNumFlds:
            jsonRow = new  JsonObject().
            jsonarray:Add(jsonRow).
            jsonRow:Add("fieldName",GetPolicyFieldName(ttCdcFieldPolicy.CdcTablePolicyName,i)).    
        end.*/    
    end method.
    
    method public override logical Find (pName as character):
        find ttCdcFieldPolicy where ttCdcFieldPolicy.FieldName = pname  no-error.
        return avail ttCdcFieldPolicy.                             
    end method.
    
    method public override logical Delete(pName as char):
        find ttCdcFieldPolicy where ttCdcFieldPolicy.FieldName = pname  no-error.
        if avail ttCdcFieldPolicy then
            return Remove().
        return false.                                  
    end method.
    
    method public override logical CanFind(pid as integer):
        //return can-find(ttCdcFieldPolicy where  ttCdcFieldPolicy.CdcPolicyId = pid ).       
    end.
	
	method public override logical CanFind (pName as char):
        return can-find(ttCdcFieldPolicy where  ttCdcFieldPolicy.CdcTablePolicyName = pName ).            
    end method.
    
    method public override logical Find(pid as integer):
        //find ttCdcFieldPolicy where ttCdcFieldPolicy.CdcPolicyId = pid  no-error.
        return avail ttCdcFieldPolicy.                             
    end.
    
    method protected override char FindExpression(pid as int):
        return "ttCdcFieldPolicy.CdcPolicyId = " + quoter(pid).
    end method.
    
    method public override character ColumnSource(pcColumn as char):
        //message "ColumnSource in FPContext" view-as alert-box.
        if pcColumn = "CdcTablePolicyState" then
            pcColumn = "CdcTablePolicy.State".
        else if pcColumn begins "Values[" then
            pcColumn = replace (pcColumn,"Values","StringValues").
        return super:ColumnSource(pcColumn).
    end.
    
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):     
        return new CdcFieldPolicySet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        return new CdcFieldPolicy(this-object,preq). 
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

        lTrack = temp-table ttCdcFieldPolicy:tracking-changes.
        //message pRow:KeyValue view-as alert-box.
        for each copytable on error undo, throw: 
            
            do on error undo, throw:
                //message copytable.TableName pRow:FieldValue("TableName") view-as alert-box.
                find first bCdcFieldPolicy where bCdcFieldPolicy.FieldName = copytable.FieldName and bCdcFieldPolicy.TableName = copytable.TableName no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bCdcFieldPolicy then
                do: 
                    create bCdcFieldPolicy.
                    bCdcFieldPolicy.FieldName  = copytable.FieldName  .
                end.    
                if valid-object(pRow) then
                do:
                    ctable = pRow:FieldValue("TableName").  
                    if cTable = "" then 
                    do:
                        undo, throw new AppError("Cannot add field policy to a CDC table policy that does not belong to a table.",?).
                    end.
                    
                    if pRow:KeyValue = "" or pRow:KeyValue = ? then 
                    do:
                        undo, throw new AppError("Cannot create CDC policy with unknown or blank policy name.",?).
                    end.
                   /* if not int(pRow:FieldValue("NumFields")) > 0 then
                    do:
                        undo, throw new AppError("Cannot add field policy to a cdc table policy that has no fields.",?).
                    end.    */            
                end.    
                catch e as Progress.Lang.Error :
                    if avail bCdcFieldPolicy then delete bCdcFieldPolicy.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("CdcFieldPolicy",e).
                    else 
                        dataError:AddMessage(e).                     
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
      
        temp-table ttCdcFieldPolicy:tracking-changes = true. 
        do on error undo, throw:  
        for each copytable:   
            create ttCdcFieldPolicy.    
            buffer-copy copytable except fieldname to ttCdcFieldPolicy. //skip the FieldName from buffer copy since we want FieldName to be set manually 
            if valid-object(pRow)  then 
            do:
                ttCdcFieldPolicy.CdcTablePolicyName = pRow:KeyValue.
                ttCdcFieldPolicy.TableName = pRow:FieldValue("TableName").
                iNumFlds = int(pRow:FieldValue("NumFields")).
                ttCdcFieldPolicy.FieldName = copytable.FieldName.
            end.
            else do:
                /* append policy name to make field unique when bulk create takes place.
                   @TODO need to have a better solution */
                ttCdcFieldPolicy.FieldName = copytable.FieldName + "@" + copytable.CdcTablePolicyName. 
            end.
            /*            
            message "name:" copytable.CdcPolicyId skip "field:" copytable.FieldName skip "table:"copytable.TableName 
            skip "id:" copytable.CdcFieldId  view-as alert-box. 
              
            //message "name:" ttCdcFieldPolicy.CdcTablePolicyName skip "field:"ttCdcFieldPolicy.FieldName skip "table:"ttCdcFieldPolicy.TableName 
            //skip "id:" ttCdcFieldPolicy.CdcPolicyId view-as alert-box.
            assign
              //ttCdcFieldPolicy.CdcPolicyId = copytable.CdcFieldId 
              //ttCdcFieldPolicy.CdcFieldId = copytable.CdcFieldId
              ttCdcFieldPolicy.FieldName = copytable.FieldName
              ttCdcFieldPolicy.Entity = copytable.Entity
              ttCdcFieldPolicy.IdentifyingField = copytable.IdentifyingField              
              .
            if valid-object(pRow)  then 
            do:  
                ttCdcFieldPolicy.CdcPolicyId = pRow:FieldValue("CdcPolicyId")  .            
                ttCdcFieldPolicy.CdcTablePolicyName = pRow:KeyValue.                
                ttCdcFieldPolicy.TableName = pRow:FieldValue("TableName").
                message "key:" ttCdcFieldPolicy.CdcTablePolicyName skip "tname:" ttCdcFieldPolicy.TableName view-as alert-box.
                //ttCdcFieldPolicy.CdcPolicyId = pRow:KeyValue + quoter(Count).
                iNumFlds = int(pRow:FieldValue("NumFields")).
            end.  
            else do:
                ttCdcFieldPolicy.CdcPolicyId = copytable.CdcFieldId.
                ttCdcFieldPolicy.CdcTablePolicyName = copytable.CdcTablePolicyName.                
                ttCdcFieldPolicy.TableName = copytable.TableName.
                message "key:" ttCdcFieldPolicy.CdcTablePolicyName skip "tname:" ttCdcFieldPolicy.TableName view-as alert-box.
                end. */
                
             Count = Count + 1.         
            OnRowCreated().
        end.
        end.
        catch e as Progress.Lang.Error :
            if e:GetMessageNum(1) = 132 then
                   undo, throw new IllegalOperationError("Found duplicate field value for CDC field policy.",?).
            else undo, throw e.
        end catch.
        finally:
            temp-table ttCdcFieldPolicy:tracking-changes = lTrack.
        end finally.
            
    end method.

	method override protected void CopyTable( input cntxt as IDataAdminModel ):
		define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
	end method.
	
	method private character GetCreateError(newField as ICdcFieldPolicy):
        //return GetCreateError(newField:CdcTablePolicyName). 
    end method.	

	method override public void CreateRow( input entity as IDataAdminElement ):
		/* if class cast error - the default syserror seems sufficent */
        CreateRow(cast(entity,IField)).
	end method.
	
	method public void CreateRow(fieldPolicy as ICdcFieldPolicy):
        define variable validateError as DataContextError no-undo.
        define variable ltrack        as logical          no-undo.
        lTrack = temp-table ttCdcFieldPolicy:tracking-changes .
        temp-table ttCdcFieldPolicy:tracking-changes = true.
        /*        ValidateDomain(policyDetail).*/
        
        do on error undo, throw: 
            Count = Count + 1.
            create ttCdcFieldPolicy.
            assign 
                Count = Count + 1
                ttCdcFieldPolicy.CdcTablePolicyName = fieldPolicy:CdcTablePolicy:Name
                ttCdcFieldPolicy.CdcPolicyId   = string(fieldPolicy:Id)
                ttCdcFieldPolicy.IdentifyingField = fieldPolicy:IdentifyingField
                ttCdcFieldPolicy.TableName = fieldPolicy:CdcTablePolicy:Table:Name.

            OnRowCreated().      
            catch e as Error:  
                delete ttCdcFieldPolicy.
                undo, throw new DataContextError(GetCreateError(fieldPolicy),Name,e).  
            end catch.  
        end.
        finally:
            temp-table ttCdcFieldPolicy:tracking-changes = ltrack.               
        end finally.
    end method.
    
    method public void CreateRow(PolicyName as char, fieldname as char, idenfield as integer):
        define variable validateError as DataContextError no-undo.
        define variable ltrack        as logical          no-undo.
        def var fldpil as OpenEdge.DataAdmin.CdcFieldPolicy no-undo.
        lTrack = temp-table ttCdcFieldPolicy:tracking-changes .
        temp-table ttCdcFieldPolicy:tracking-changes = true.
        /*        ValidateDomain(policyDetail).*/
        do on error undo, throw: 
            Count = Count + 1.
            create ttCdcFieldPolicy.
            assign 
                Count = Count + 1
                ttCdcFieldPolicy.CdcTablePolicyName        = PolicyName
                //ttCdcFieldPolicy.CdcPolicyId   = string(fieldPolicy:Id)
                ttCdcFieldPolicy.IdentifyingField = idenfield
                ttCdcFieldPolicy.FieldName = fieldName + "@" + PolicyName.
            OnRowCreated().      
            catch e as Error:  
                delete ttCdcFieldPolicy.
                undo, throw new DataContextError(policyName,e).  
            end catch.  
        end.
        finally:
            temp-table ttCdcFieldPolicy:tracking-changes = ltrack.               
        end finally.
    end method.

	method override public character GetJoinFields( input parentid as character ):
		if parentid = "CdcTablePolicies" then 
            return "Name,CdcTablePolicyName".
        return "". 
	end method.
	
	method public override character GetServerJoinFields(parentid as char):
        if parentid = "CdcFieldPolicies" then 
            return "CdcPolicyId,CdcPolicyId".
        else if parentid = "CdcTablePolicies" then 
            return "CdcPolicyId,CdcPolicyId".
        return "".     
    end.
    /* form a query expression which finds unique field for policy based on table name and policy name.
       we need this since same fieldname can exist in different tables and same table names can exist in different schemas 
       @TODO not satisfied with this solution, need a nicer way */   
    method public override character ColumnExpression(pcColumn as char,pcOperator as char,pcValue as char):
        define variable cExpress as character no-undo.
        define variable cFieldName as character no-undo.
        define variable cTableName as character no-undo.
        define variable cPolicyName as character no-undo.
        if pcColumn = "ttCdcFieldPolicy.FieldName" then
        do:
            split(pcValue,output cFieldName,output cTableName,output cPolicyName).
            if lookup(pcOperator,"eq,=") > 0 then
            do:
                if cTableName =  ""  and cPolicyName = "" then
                    cExpress = "(ttCdcFieldPolicy.fieldName " + pcOperator + " " + quoter(cFieldName)
                             + ")". 
                else
                if cTableName = "" and cPolicyName > "" then
                    cExpress = "(ttCdcFieldPolicy.fieldName " + pcOperator + " " + quoter(cFieldName + "@" + cPolicyName)
                             + ")".
                else cExpress = "(ttCdcFieldPolicy.fieldName " + pcOperator + " " + quoter(cFieldName + "@" + cPolicyName )
                              + " and ttCdcFieldPolicy.TableName " + pcOperator + " " + quoter(cTableName)
                              + " and ttCdcFieldPolicy.CdcTablePolicyName " + pcOperator + " " + quoter(cPolicyName)
                              + ")". 
            end. 
            return cExpress.   
        end.    
        return super:ColumnExpression(pccolumn,pcOperator,pcValue).
    end method.
    
    /* split the field property which has field name, table name and policy name */ 
    method private void Split(pcValue as char,output cField as char, output cTable as char, output cpolicy as char): 
        if num-entries(pcvalue,".") > 1 then do:
            cField = entry(3,pcvalue,".").
            cTable = entry(2,pcvalue,".").
            cPolicy = entry(1,pcvalue,".").
        end.
       else 
        if num-entries(pcvalue,"@") > 1 then do:
            cField = pcvalue.
            cPolicy = entry(2,pcvalue,"@").
        end.
        else cField = pcValue.
        /*       
        cTable = entry(2,pcvalue,".").
        cPolicy = entry(1,pcvalue,".").*/
             
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
            if SchemaScope:CdcTablePolicyContext:Find(hBuffer::CdcTablePolicyName) then 
            do:
                jsonArray = pjson:GetJsonArray("values").
                inum = GetPolicyNumFields(hBuffer::CdcTablePolicyName).
                if inum = ? then
                    undo, throw new IllegalArgumentError("CdcTablePolicy " + quoter(hBuffer::CdcTablePolicyName) + " not found.").
      
                if inum = 0 then
                    undo, throw new IllegalArgumentError("CdcTablePolicy " + quoter(hBuffer::CdcTablePolicyName)  + " has no fields defined.").
      
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
                undo, throw new UnsupportedOperationError("Import of cdc field policy values from json to new collection without policy parent.").
            /*     inum = jsonArray:Length.*/
            end.    
            cName = "value". 
            do i = 1 to inum on error undo,leave:
                json  = jsonArray:GetJsonObject(i).
                cfldname = json:GetCharacter("fieldName").
                cTable =  GetPolicyTableName(hBuffer::CdcTablePolicyName).
                iFldnum = GetPolicyFieldNumber(hBuffer::CdcTablePolicyName,cTable,cfldname ).
                if iFldnum = 0 then 
                    undo, throw new IllegalArgumentError("Json fieldName " + cfldname + " is not defined for the policy.").
                cDataType = GetPolicyFieldDataType(hBuffer::CdcTablePolicyName,iFldnum).
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
                               // CheckValue(cval,"int64").
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
                               // CheckValue(cval,"integer").
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
                            //CheckValue(cval,"logical").
                        end catch.
                    end.
                    
                    when "datetime" then
                        cVal = string(json:GetDatetime(cname)).
                    when "datetime-tz" then
                        cVal = string(json:GetDatetimeTZ(cname)).
                    when "decimal" then
                    do on error undo,leave: 
                        //cVal = AmericanNumericString(json:GetDecimal(cname)).
                        catch e as Progress.Lang.Error :
                            cVal = json:GetCharacter(cname).
                            //CheckValue(cval,"decimal").
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
    
    
    
    method public void AssertScope( ):
        define variable cType as character no-undo.
        if not valid-object(SchemaScope) then
            undo, throw new IllegalOperationError("Cannot update value for a  field policy that does not belong to a cdc table policy."). 
    end.
    
    method public int GetPolicyNumFields(pcPolicyName as char):
        if not valid-object(SchemaScope) then
            return ?. 
        if SchemaScope:CdcTablePolicyContext:Find(pcPolicyName) then
            return SchemaScope:CdcTablePolicyContext:TableHandle:default-buffer-handle::NumFields.
        return ?.      
    end.
    
    method public char GetPolicyTableName(pcPolicyName as char):
        if not valid-object(SchemaScope) then
            return ?. 
        if SchemaScope:CdcTablePolicyContext:Find(pcPolicyName) then
            return SchemaScope:CdcTablePolicyContext:TableHandle:default-buffer-handle::TableName.
        return ?.      
    end.
    
    method public char GetPolicyFieldDataType(pcPolicyName as char,  pinum as int):
        /*if SchemaScope:CdcTablePolicyFieldContext:Find(pcPolicyName,pinum) then
            return SchemaScope:CdcTablePolicyFieldContext:TableHandle:default-buffer-handle::DataType.
        return ?.*/
    end.
    
    method public char GetPolicyFieldName(pcPolicyName as char,  pinum as int):
        /*if SchemaScope:CdcTablePolicyFieldContext:Find(pcPolicyName,pinum) then
            return SchemaScope:CdcTablePolicyFieldContext:TableHandle:default-buffer-handle::FieldName.
        return ?.*/
    end.
    
    method public void UpdatePartitionDefault(pcPolicyName as char, pcfield as char, pcold as char, pcnew as char):
        define variable partitionContext as PartitionContext no-undo.                                    
        define variable lTrack as logical no-undo.
        if pcfield = "CdcTablePolicyName" then 
        do:
            partitionContext = cast(getChild("partitions"),PartitionContext).
            for each ttCdcFieldPolicy where ttCdcFieldPolicy.CdcTablePolicyName = pcPolicyName:
                partitionContext:UpdateFieldPolicyDefault(ttCdcFieldPolicy.CdcTablePolicyName,pcfield,pcold,pcnew). 
            end.
        end.
        else do on error undo, throw:
            lTrack = temp-table ttCdcFieldPolicy:tracking-changes.
            temp-table ttCdcFieldPolicy:tracking-changes = true.
           /* for each ttCdcFieldPolicy where ttCdcFieldPolicy.CdcTablePolicyName = pcPolicyName:
                case pcField:
                    when "IdentifyingField" then 
                    do:
                        if ttCdcFieldPolicy.IdentifyingField = pcold then
                        do:
                            ttCdcFieldPolicy.IdentifyingField = pcnew.
                            ValueChanged(pcField,pcold,pcnew). 
                        end.    
                    end.                                 
                end.    
            end.    */
            finally:
                temp-table ttCdcFieldPolicy:tracking-changes = lTrack.
            end finally.  
        end.
    end method.
    
    method protected override void ValueChanged(pFieldName as char,pcOldValue as char,pNewValue as char).        
        define variable partitionContext as PartitionContext no-undo.                                    
        super:ValueChanged(pfieldname,pcoldvalue,pNewValue).
        /* if new policy then the partitions must be updated with default values */
        if pFieldName begins "Default" 
        and (buffer ttCdcFieldPolicy:row-state = row-created 
             /* rootid = rowid implies new tenant */
             or RootId = rowid(ttCdcFieldPolicy) ) then
        do: 
            partitionContext = cast(getChild("Partitions"),PartitionContext).
            partitionContext:UpdateFieldPolicyDefault(ttCdcFieldPolicy.CdcTablePolicyName,pFieldName,pcOldValue,pNewValue).
        end.
    end method.
    
    method public int GetPolicyFieldNumber(pcPolicyName as char, pcTable as char, pcfield as char):
        /*if SchemaScope:CdcTablePolicyFieldContext:Find(pcPolicyName,pcTable,pcfield) then
            return SchemaScope:CdcTablePolicyFieldContext:TableHandle:default-buffer-handle::Number.
        return 0.*/
    end.
    
     method public void UpdateCdcTablePolicyName(pcOldname as char, pcNewname as char):
        define variable lTrack as logical no-undo.
        define buffer bCdcFieldPolicy for ttCdcFieldPolicy.
        lTrack = temp-table ttCdcFieldPolicy:tracking-changes.
        temp-table ttCdcFieldPolicy:tracking-changes = false.
        for each bCdcFieldPolicy where bCdcFieldPolicy.CdcTablePolicyName = pcOldname:
            assign 
                bCdcFieldPolicy.CdcTablePolicyName= pcNewname.
        end.    
        finally:
            temp-table ttCdcFieldPolicy:tracking-changes = lTrack.
        end.
    end. 
    
    method public override void SerializeRow(phStream as handle):
        export stream-handle phStream
            "Field"
            ttCdcFieldPolicy.CdcTablePolicyName
            ttCdcFieldPolicy.FieldName
            ttCdcFieldPolicy.IdentifyingField
            ttCdcFieldPolicy.Misc
            .
    end method.
    
    method protected override logical DeserializeRow(phStream as handle, plReplace as log):
        define variable lok                   as logical no-undo.
        define variable tCdcTablePolicyName  like ttCdcFieldPolicy.CdcTablePolicyName no-undo. 
        define variable tCdcPolicyId         like ttCdcFieldPolicy.CdcPolicyId no-undo.
        define variable tIdentifyingField         like ttCdcFieldPolicy.IdentifyingField no-undo.
        define variable tObjectNumber  like ttCdcFieldPolicy.ObjectNumber no-undo.
       define variable lnew                  as logical no-undo. 
        do on endkey undo, leave:
            import stream-handle phStream
                tCdcTablePolicyName
                tCdcPolicyId
                tIdentifyingField
                tObjectNumber
                .
            if plReplace then
            do: 
                //find ttCdcFieldPolicy where ttCdcFieldPolicy.CdcTablePolicyName= tname no-error.
            end.
            
            if not plReplace or not avail ttCdcFieldPolicy then 
            do:
                create ttCdcFieldPolicy. 
                lnew = true.
            end.        
            assign 
                ttCdcFieldPolicy.CdcTablePolicyName  = tCdcTablePolicyName
                ttCdcFieldPolicy.CdcPolicyId = tCdcPolicyId
                ttCdcFieldPolicy.IdentifyingField = tIdentifyingField
                ttCdcFieldPolicy.ObjectNumber = tObjectNumber
                .
            lok = true.    
          
            catch e as Progress.Lang.Error :
                undo, throw e.
            end catch. 
        end.
        if not lok then   
        do:
            if avail ttCdcFieldPolicy and lnew then
                delete ttCdcFieldPolicy.
        end.    
        else if lok and lnew then     
            do: 
                Count = Count + 1.
                OnRowCreated().
            end.        
        return lok.
        catch e as Progress.Lang.Error :
            if avail ttCdcFieldPolicy and lnew then
                delete ttCdcFieldPolicy.
            undo, throw e.
        end catch.    
    end method. 
    
    method public void CreateRow(pcPolicyName as char,pname as char):
        define variable validateError as DataContextError no-undo.
        define variable lTrack        as logical          no-undo.
        lTrack = temp-table ttCdcFieldPolicy:tracking-changes.
        temp-table ttCdcFieldPolicy:tracking-changes = true.
        /*        ValidateArea(area).*/
        
        do on error undo, throw: 
            create ttCdcFieldPolicy.
            assign 
                ttCdcFieldPolicy.CdcTablePolicyName = pcPolicyName.
            Count = Count + 1.
            OnRowCreated().        
            catch e as Error:  
                delete ttCdcFieldPolicy.
                undo, throw new DataContextError(GetCreateError(name),"CdcFieldPolicy",e).  
            end catch.  
        
        end.
        finally:
            temp-table ttCdcFieldPolicy:tracking-changes = lTrack.
        end.
    end method.
    
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

	method public character WriteFieldAssignments( input pstream as handle, input pcname as character, input piAt as integer, input pbuf as handle ):
		return "".
	end method.
	
	/* genereate code for value assignment */
    method private void WriteValuesAsCode(phStream as handle,pcinstName as char,prec as recid,table ttCdcFieldPolicy):
        define variable i         as integer    no-undo.
        define variable iNumFlds  as integer    no-undo.
        define variable ctype     as character no-undo.
        define variable cfld as character no-undo.
        define variable cvaltxt as character no-undo.
        define variable cvalue as character no-undo.
        define variable ddat as date no-undo.
        find ttCdcFieldPolicy where recid(ttCdcFieldPolicy) = prec.
     
        iNumFlds = GetPolicyNumFields(ttCdcFieldPolicy.CdcTablePolicyName).
        cvaltxt = if iNumFlds = 1 then "value" else "values".
        //put stream-handle phStream    unformatted skip
                        
        do i = 1 to iNumFlds:
            /* TBD */
        end.
        
        
    end method.    

	method public void WriteFieldStatements( input phstream as handle, input pcvarname as character, input phbuf as handle ):
		define variable htbl as handle no-undo.
         define variable rid as recid no-undo.
         rid = phbuf:recid.
         htbl = phbuf:table-handle.
         WriteValuesAsCode(phStream,pcvarname,rid,table-handle htbl by-reference).
	end method.

end class.