/*************************************************************/
/* Copyright (c) 2015-2018 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : CDC Context/Model
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Wed Nov 18 2015
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IMultiTenantScope.
using OpenEdge.DataAdmin.Binding.Factory.ISchemaScope.
using OpenEdge.DataAdmin.Binding.FieldContext.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IDataTree.
using OpenEdge.DataAdmin.Binding.IndexContext from propath.
using OpenEdge.DataAdmin.Binding.LocalIndexContext from propath.
using OpenEdge.DataAdmin.Binding.PartitionContext.
//using OpenEdge.DataAdmin.Binding.CdcTablePolicyFieldContext.
using OpenEdge.DataAdmin.Binding.CdcFieldPolicyContext.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.Query.TenantGroupTenantQuery.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.Binding.TableContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.*.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDataAdminService.
using OpenEdge.DataAdmin.IField.
using OpenEdge.DataAdmin.ICdcTablePolicy.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.SaveRequest.
using OpenEdge.DataAdmin.CdcTablePolicy.
using OpenEdge.DataAdmin.CdcTablePolicySet.
using OpenEdge.DataAdmin.Support.TenantGroupTenantSet.
using OpenEdge.DataAdmin.Support.TenantGroupTenantSet.
using Progress.Lang.*.
using Progress.Json.ObjectModel.JsonObject from propath.
using OpenEdge.DataAdmin.DataAccess.DataAccessError from propath.
using OpenEdge.DataAdmin.Binding.Factory.IContextScope.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.CdcTablePolicyContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/cdctablepolicy.i}
    define buffer bpolicy for ttCdcTablePolicy.
    
    /* NOTE: needed for tracking changes*/ 
    define private dataset dsPolicy serialize-name "root" for ttCdcTablePolicy.
 
    define temp-table copytable reference-only like ttCdcTablePolicy.
      
    define temp-table ttPartitionIdRequest no-undo
        field Partitionid as int
        field policyname as char
        index partname as  unique policyname
        index partidx as primary unique partitionid.
        
    define private variable mCreate as logical no-undo.
    define variable mPartitionAfterQuery as handle no-undo.
    define private variable ValidDefaultLevelList as char init "0,1,2" no-undo.
    define private variable ValidDefaultLevelString as char init "~"0~" ~"1~" and ~"2~"" no-undo.
    define private variable SchemaScope as ISchemaScope no-undo.
    define private variable FieldContext as FieldContext no-undo.
    define private variable IndexContext as IndexContext no-undo.
 
    define public override property TableHandle as handle no-undo 
        get():
            return temp-table ttCdcTablePolicy:handle.
        end get.
   
    define public override property KeyFields as character  no-undo  
        get():
            return "Name". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bpolicy for ttCdcTablePolicy.
            if Count = ? then
            do:
                Count = 0.
                for each bpolicy:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        protected set.
 
    define public property CreateReadOnlyError as char 
          init "The property can only be edited after the policy has been created." no-undo get.  
    
    constructor public CdcTablePolicyContext ():         
        super ("CdcTablePolicy").
        ExportWithRoot = false.
        CanGenerateCode = true.

    end constructor.

    constructor public CdcTablePolicyContext (pScope as ISchemaScope):
        super ("CdcTablePolicy",pScope).
        SchemaScope = pScope.
        ExportWithRoot = false.
        CanGenerateCode = true.
    end method.
    
    method override protected void InitChildren ():
        define variable fieldpolicycontext as CdcFieldPolicyContext no-undo.  
        fieldpolicycontext = new CdcFieldPolicyContext().       
        AddChild(fieldpolicycontext).
    end method.
    
    method override protected void InitChildren (pscope as IContextScope):
        initChildren(cast(pScope,ISchemaScope)).
    end method.
    
    method protected void InitChildren (pscope as ISchemaScope):        
        AddChild(pScope:CdcFieldPolicyContext).
    end method.
    
    /* temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsPolicy:handle. 
    end method.
    
    method public override void CreateRow(entity as IDataAdminElement):
        /* the default syserror has all info */
        CreateRow(cast(entity,ICdcTablePolicy)).    
    end method.
    
    method public override character GetJoinFields(parentid as char):
        return "".
    end.
    
    /*
    /* detail has different join on server */
    method protected override handle GetRequestDataset():
        /* way too much data to load up front - just load the fields */
        return CreateServerDataset("").  /* final - calls createDataset true */
    end method. */
    
       method public void FillNewFieldPolicies (pcPolicyname as char) :
        define variable request as IFetchRequest   no-undo.
        request = GetNewFieldPolicyRequest(pcPolicyname,"","").
        FillNewFieldPolicies(request).
    end method. 
    
    /* fill details from data - generate name using substitute base and substitute argstemplate 
        @param - policy name
        @param  pcSubstituteBase  optional base template for detail name to be used in ABL substitute 
        @param  pcSubstituteArgs  optional args  to be used in ABL substitute for detail name
         see substitute param description/format in IPartitionPolicy:AddDetailsFromData(pcSubstituteBase,pcSubstituteArgs) */
    method public void FillNewFieldPolicies (pcPolicyname as char,pcSubstituteBase as char,pcSubstituteArgs as char) :
        define variable request as IFetchRequest   no-undo.
        request = GetNewFieldPolicyRequest(pcPolicyname,pcSubstituteBase,pcSubstituteArgs).
        FillNewFieldPolicies(request).
    end method.  
    
    /* fill details from data - generate name from tokenized template 
        @param - policy name
        @param  pcTemplate - see description/format in IPartitionPolicy:AddDetailsFromData(template) */
    method public void FillNewFieldPolicies (pcPolicyname as char,pcTemplate as char) :
        define variable cSubstitute as character no-undo.
        define variable cSubstituteArgs as character no-undo.
        define variable request as IFetchRequest   no-undo.
        ConvertTokensToSubstitute(pcTemplate,output cSubstitute, output cSubstituteArgs).
        request = GetNewFieldPolicyRequest(pcPolicyname,cSubstitute,cSubstituteArgs).
        FillNewFieldPolicies(request).
    end method.  
    
    method protected void FillNewFieldPolicies( request as IFetchRequest   ):
        SchemaScope:CdcFieldPolicyContext:FillData(request).
    end method.     
    
    method private void ConvertTokensToSubstitute( pctemplate as char ,output pcresult  as char, output pcTokens as char):
        define variable i as integer no-undo.
        define variable iPos as integer no-undo.
        define variable iEndPos  as integer no-undo.
        define variable cToken as character no-undo.
        define variable cRest as character no-undo.
        define variable iCnt as integer no-undo.
        
        /* escape any & with itself for ABL substitute   */
        cRest = replace(pctemplate,'&','&&').
        
        do i = 1 to length(pctemplate):
            iPos = index(cRest,"$~{").
            if iPos > 0 then 
            do:
                if iPos > 1 then
                   pcResult = pcResult + substr(cRest,1,iPos - 1).
                
                iEndPos = index(cRest,"~}").
                /* found ~} before end, use two substr to find real end 
                   (could really do this for all cases...) 
                  note that this will currently just give an unsupported error, but 
                  it's difficult to do validation of left curlybraces here when curly braces are  
                  by the time they are checked the valid ones are removed by this code..   
                   */
                if iEndPos < ipos then 
                do:
                    assign         
                        cToken  = substr(cRest,iPos + 2) 
                        iEndPos = index(cToken,"~}")
                        cToken  = substr(cToken,1,iEndPos - 1)
                        cRest = substr(cRest,iPos + iEndPos + 2). 
                end.
                else
                    assign
                        cToken  = substr(cRest,iPos + 2,iEndPos - iPos - 2)
                        cRest = substr(cRest,iEndPos + 1).
                assign     
                    iCnt = iCnt + 1   
                    pcTokens = pcTokens + (if pcTokens = "" then "" else ",") + cToken 
                    pcResult = pcResult + '&' + string(iCnt) 
                   .
            end. 
            else do:      
               pcResult = pcResult + cRest. 
               leave.
            end.  
        end.
        
    end method.
    
    /*  get request for details from data 
        @param - policy name
        @param  pcSubstituteBase  optional template for detail name to be used in ABL substitute 
        @param  pcSubstituteArgs  optional args  to be used in ABL substitute for detail name
   
        Note: if substitute params not passed we check if a template is imported from json and 
              convert it into substitute params  
    */  
    method protected IFetchRequest GetNewFieldPolicyRequest(pcPolicyname as char,pcSubstituteBase as char,pcSubstituteArgs as char) :
        define variable req as IFetchRequest no-undo.
        define variable h as handle no-undo.
        define variable cflds as character extent no-undo.
        define variable i as integer no-undo.    
        define variable cquery as character no-undo.
        define variable cFieldPolicynameTemplate as character no-undo.
        define variable cFPolicyField as character no-undo.
        if pcPolicyname = ? then 
            undo, throw new UnknownValueError("GetNewFieldPolicyRequest","Policyname").
        if this-object:Find(pcPolicyname) then
        do:
            h = CreateServerDataset().
            req = new FetchRequest(this-object:Name,Id,h,no).
            
            if ttCdcTablePolicy.TableName = "" or ttCdcTablePolicy.tableName  = ? then
               undo, throw new UnsupportedOperationError("Cannot request new field policy for a cdc policy with no table").
               
            cQuery = "where ttCdcTablePolicy.Name = "      + quoter(ttCdcTablePolicy.Name) 
                   + " and  ttCdcTablePolicy.TableName = " + quoter(ttCdcTablePolicy.TableName) 
                   .
            /*       
            /* if not passed check if loaded from json */
            if pcSubstituteBase = "" or pcSubstituteBase = ? then
            do:    
                cFieldPolicynameTemplate =  ttCdcTablePolicy.FieldPolicyNameTemplate. 
                if cFieldPolicynameTemplate > "" then
                do:
                    ConvertTokensToSubstitute(cFieldPolicynameTemplate,output pcSubstituteBase, output pcSubstituteArgs ).
                end.      
                else do:
                    pcSubstituteBase = "&1-&2".
                    pcSubstituteArgs = "CdcTablePolicyName,Number".
                end.   
            end.
            /* add name temaplate substititute to query if specified */
            do i = 1 to num-entries(pcSubstituteArgs):
                cFPolicyField = entry(i,pcSubstituteArgs).
                if(cFPolicyField = "Number") then
                    cFPolicyField  = "ttCdcFieldPolicy.Number".
                else  
                    cFPolicyField = SchemaScope:CdcFieldPolicyContext:ColumnSource(cFPolicyField).
                
                entry(i,pcSubstituteArgs) = cFPolicyField.
            end.
            cQuery = cQuery 
                   + " and  ttCdcTablePolicy.DetailNameSubstituteBase = " + quoter(pcSubstituteBase)         
                   + " and  ttCdcTablePolicy.DetailNameSubstituteNames = " + quoter(pcSubstituteArgs).
          */
            /*cflds = SchemaScope:CdcTablePolicyFieldContext:GetFieldNames(pcPolicyname).
            if extent(cflds) = ? then
                undo, throw new UnsupportedOperationError("Cannot request new cdc fieldpolicies for a policy with no fields").
            
            do i = 1 to extent(cflds):
                cQuery = cQuery + " and ttCdcTablePolicyField.FieldName = " +  quoter(cflds[i]) .
            end.*/                
            req:SetTableRequestType("ttCdcFieldPolicy","NEW").
            /* somewhat hacky - works like a charm due to data source columnExpression 
              - the query is used to pass request parameters. Taking advantage of the existing query passing and parsing 
              mechanisms. It is not used as a query on the server (the fields may not exist in the tt) .  */ 
            
            req:SetTableQuery("ttCdcFieldPolicy",cQuery).
            return req.
        end.
        undo, throw new IllegalArgumentError("GetFieldPolicyRequest called with invalid table policy name: " + quoter(pcPolicyname)).
    end method.   
    
    /*overide to read DetailNameTemplate which is hidden (and not persisted - only used in  adddetailsfromdata)*/
    method protected override void ReadRow(pjson as JsonObject,pcExceptColumns as char):
        define variable lhidden as logical no-undo.
        define variable hFld as handle no-undo.
        hFld = TableHandle:default-buffer-handle:buffer-field ("FieldPolicyNameTemplate").
        lhidden = hFld:serialize-hidden.
        if lhidden then
        do:
            hFld:serialize-name="fieldPolicyNameTemplate".
            hFld:serialize-hidden = false.
        end.
        super:ReadRow(pjson,pcExceptColumns).
        finally:
             if lhidden then
                hFld:serialize-hidden=true. 
        end finally.
    end method.
    
    method public override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false. 
    end method. 
    
    method private void CopyTable(input table copytable):
        define variable dataerror as DataContextError no-undo.      
        define variable lTrack as logical no-undo.
        for each copytable on error undo, throw:  
            do on error undo, throw:
                find bpolicy where bpolicy.Name = copytable.Name no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bpolicy then
                do:
                    create bpolicy.
                    bpolicy.Name = copytable.Name.               
                end.    
                catch e as Progress.Lang.Error :
                    delete bpolicy.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("CdcTablePolicy",e).
                    else 
                       dataError:AddMessage(e).                     
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        lTrack = temp-table ttCdcTablePolicy:tracking-changes.
        temp-table ttCdcTablePolicy:tracking-changes = true.
        for each copytable:
            create ttCdcTablePolicy.
            Count = Count + 1.
            buffer-copy copytable to ttCdcTablePolicy. 
            //message ttCdcTablePolicy.CdcPolicyId view-as alert-box.   
            OnRowCreated().
        end.
        temp-table ttCdcTablePolicy:tracking-changes = lTrack.
    end method.  
    
    /** fires after change - validation should have been done */
    method protected override void ValueChanged(pFieldName as char,pcOldValue as char,pNewValue as char).        
        define variable cntxt as CdcFieldPolicyContext no-undo. 
        super:ValueChanged(pfieldname,pcoldvalue,pNewValue).
        /* if new tenant then the partitions must be updated with default values */
        if pFieldName begins "Default" 
        and (buffer ttCdcTablePolicy:row-state = row-created 
             /* rootid = rowid implies new tenant */
             or RootId = rowid(ttCdcTablePolicy) ) then
        do: 
            cntxt = cast(getChild("CdcFieldPolicies"),CdcFieldPolicyContext).
            cntxt:UpdatePartitionDefault(ttCdcTablePolicy.Name,pFieldName,pcOldValue,pNewValue).
        end.
    end method.
    
    method private character GetCreateError(policy as ICdcTablePolicy):
        return this-object:GetCreateError(cast(policy,IDataAdminElement),policy:Name). 
    end method.
 
    
    method protected override void ValidateBuffer(phPolicy as handle):
        define variable hBefore as handle no-undo.
        define variable cName as character no-undo.
        if phPolicy:row-state = row-modified then
        do:
            cName = phPolicy::Name.
            if cname = ? then cName = "<unknown>".
            hBefore = phPolicy:before-buffer.
            hbefore:find-by-rowid(phPolicy:before-rowid).
            /*
            if phPolicy::Level <> hBefore::Level then
               undo, throw new CreateOnlyPropertyError(Name,cName,"Level").*/            
            
        end. 
        else if phPolicy:row-state = row-created then
        do:
            
            /*if phPolicy::IsCompositeReadOnly = true then
            do:
                cName = phPolicy::name.
                if cname = ? then cName = "<unknown>".
                undo, throw new ReadOnlyPropertyError("CdcTablePolicy",cName,"IsCompositeReadOnly",CreateReadOnlyError).
            end. */
        end.          
    end method.      
    
    method private void ValidatePolicy(policy as ICdcTablePolicy):
        define variable validateError as DataContextError no-undo.
        define variable lError as logical no-undo.
        define variable cErr as character extent 8 no-undo.
        define variable i as integer no-undo.   
        /*
            if not valid-object(policy:DataArea) then
            do:
                cErr[1] = "DataArea is undefined.". 
                lerror = true.
            end.
            else if valid-object(Service) and policy:DataArea:Service <> Service then
            do:
                cErr[1] = "DataArea " + quoter(policy:DataArea:Name) + " does not exist in service.".              
                lerror = true.
            end.
                 
            if not valid-object(policy:IndexArea) then
            do:
                cErr[2] = "IndexArea is undefined". 
                lerror = true.
            end.
            else if valid-object(Service) and policy:IndexArea:Service <> Service then
            do:
                cErr[2] = "IndexArea " + quoter(policy:IndexArea:Name) + " does not exist in service.".              
                lerror = true.
            end.
            */
            if policy:Level = ? then
            do:
                cErr[4] = "Level cannot be unknown.".              
                lerror = true.
            end.
           
           /* else if lookup(policy:Level,ValidDefaultLevelList) = 0 then
            do:
                cErr[4] = quoter(policy:Level) + " is not a valid Level value. Valid values are " + ValidDefaultLevelString + ".".              
                lerror = true.
            end. */
         if lError then 
        do:
            validateError = new DataContextError(GetCreateError(policy)).
            do i = 1 to extent(cErr):
                if cErr[i] > "" then
                    validateError:AddMessage("* " + cErr[i],?).
          
            end.
            undo, throw validateError.
        end.
        
    end method.    
    
     /* support many-to-many to fields (tenants as child) */    
    method protected override IDataAdminModel GetNamedChild(pname as char):
        define variable i as integer no-undo.
        if pName = "cdcFieldPolicies" then 
        do:
            return GetChild("cdcFieldPolicies").
        end.
            
        if pName = "fields" then
        do:
            if not valid-object(FieldContext) then
            do:
                if valid-object(SchemaScope) then
                do:
                    FieldContext = cast(SchemaScope:GetlookupContext("Field"),FieldContext).
                end.
            end.
            return FieldContext.
        end.
        if pName = "indexes" then
        do:
            if not valid-object(IndexContext) then
            do:
                if valid-object(SchemaScope) then
                do:
                    IndexContext = cast(SchemaScope:GetlookupContext("Index"),IndexContext).
                end.
            end.
            return IndexContext.
        end.
        return super:GetNamedChild(pname).
     
    end method.    
 
     method public override handle extent GetQueryHandles(pcParent as char):
        define variable h as handle extent 2 no-undo.
/*        if pcParent = "tenantGroups" then                                                    */
/*        do:                                                                                  */
/*            h[1] = ContextFactory:TenantGroupMemberContext:TableHandle:default-buffer-handle.*/
/*            h[2] = TableHandle:default-buffer-handle.                                        */
/*            return h.                                                                        */
/*        end.                                                                                 */
/*        else                                                                                 */
            return super:GetQueryHandles(pcParent). 
    end method.
    
    method public void CreateRow(policy as ICdcTablePolicy):
        define variable validateError as DataContextError no-undo.
        define variable ltrack as logical no-undo.
        //message "createRow" view-as alert-box.
        lTrack = temp-table ttCdcTablePolicy:tracking-changes .
        temp-table ttCdcTablePolicy:tracking-changes = true.
        if valid-object(Service) then
           ValidatePolicy(policy).
        
        do on error undo, throw: 
            create ttCdcTablePolicy.
            assign 
                ttCdcTablePolicy.Name = policy:Name
                 ttCdcTablePolicy.TableName = policy:Table:name
                 ttCdcTablePolicy.Entity = policy
                ttCdcTablePolicy.State = int(policy:State)
                ttCdcTablePolicy.Description =  policy:Description
                ttCdcTablePolicy.Level =  int(policy:Level)
                ttCdcTablePolicy.Instance =  int(policy:Instance).
                if valid-object(policy:DataArea) then
                    ttCdcTablePolicy.DataAreaName  = policy:DataArea:Name.
                if valid-object(policy:IndexArea) then
                    ttCdcTablePolicy.IndexAreaName = policy:IndexArea:Name.               
                
            Count = Count + 1.
            OnRowCreated().      
            catch e as Error:  
                delete  ttCdcTablePolicy.
                undo, throw new DataContextError(GetCreateError(policy),"CdcTablePolicy",e).  
            end catch.  
        end.
        finally:
            temp-table ttCdcTablePolicy:tracking-changes = lTrack.             
        end finally.
    end method.
    
    method public override void SetTreeOptions(tree as IDataTree).
        super:SetTreeOptions(tree).
        if tree:Write then
        do:
            tree:UseDataset = false.
        end.  
    end method. 
    
    
    method public override logical CanFind(name as character):
        return can-find(ttCdcTablePolicy where ttCdcTablePolicy.Name = name).            
    end.    
     
    method public override logical Find(name as character):
        find ttCdcTablePolicy where ttCdcTablePolicy.Name = name no-error.
        return avail ttCdcTablePolicy.            
    end.   
    
    method public character FetchTableName (pCdcPolicyName as character):
        define variable lFound as logical no-undo.
        lfound = this-object:Find(pCdcPolicyName).
        if not lFound then do:
             this-object:Fetch(pCdcPolicyName).  
             lfound = this-object:Find(pCdcPolicyName).
        end.    
        
        if lFound then 
            return ttCdcTablePolicy.TableName.

        return ?.                        
    end. 
    
    method protected logical Fetch(pCdcPolicyName as character):
        define variable oMsg as IFetchRequest no-undo.
        oMsg = GetRequest(). 
        omsg:SetTableQuery(Tablehandle:name,
                           subst( " for each ttCdcTablePolicy where ttCdcTablePolicy.name = '&1'", 
                                    pCdcPolicyName)
                          ).
        FetchData(oMsg). 
    end.
 
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):
        return new CdcTablePolicySet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new CdcTablePolicy(this-object,req).
    end method.
    
    
    method protected override char FindExpression(c as char):
        return "ttCdcTablePolicy.Name = " + quoter(c).
    end method.
    
    method private void DeletePartitionAfterQuery():
        delete object mPartitionAfterQuery.
    end method. 
    
    method public override void SerializeRow(phStream as handle):
        //message "serialize" view-as alert-box.
        export stream-handle phStream
            "Table"
            ttCdcTablePolicy.Name
            ttCdcTablePolicy.Description
            ttCdcTablePolicy.State
            ttCdcTablePolicy.TableName
            ttCdcTablePolicy.DataAreaName
            ttCdcTablePolicy.IndexAreaName
            ttCdcTablePolicy.Level
            ttCdcTablePolicy.ChangeTable
            ttCdcTablePolicy.ChangeTableOwner
            ttCdcTablePolicy.EncryptPolicy
            ttCdcTablePolicy.Misc          
            .
    end method. 
    
    method protected override logical DeserializeRow(phStream as handle, plReplace as log):
        
        define variable i as integer no-undo.
        define variable ictr as integer no-undo.
        define variable lok as logical no-undo.
        define variable lnew as logical no-undo.
        define variable tblPolicy as char no-undo.
        define variable fldPolicy as char no-undo.
        define variable fldPolicyCnt as int no-undo.
        
        define variable tname like ttCdcTablePolicy.Name no-undo.
        define variable tTableName like ttCdcTablePolicy.TableName no-undo.
        define variable tDataAreaName like ttCdcTablePolicy.DataAreaName no-undo.
        define variable tIndexAreaName like ttCdcTablePolicy.IndexAreaName no-undo.       
        define variable tLevel like ttCdcTablePolicy.Level no-undo.
        define variable tFieldNames like ttCdcTablePolicy.FieldNames no-undo.
        define variable tState like ttCdcTablePolicy.State no-undo.
        define variable tSourceTableOwner like ttCdcTablePolicy.SourceTableOwner no-undo.
        define variable tIdentifyingField like ttCdcTablePolicy.IdentifyingField no-undo.
        define variable tChangeTableOwner like ttCdcTablePolicy.ChangeTableOwner no-undo.
        define variable tEncryptPolicy like ttCdcTablePolicy.EncryptPolicy no-undo.
        define variable tMisc like ttCdcTablePolicy.Misc no-undo.
        define variable tInstance like ttCdcTablePolicy.Instance no-undo.
        define variable tDescription like ttCdcTablePolicy.Description no-undo.
        define variable tChangeTable like ttCdcTablePolicy.ChangeTable no-undo.
        
        define variable currentService as IDataAdminService  no-undo.
        define variable tbl as ITable  no-undo.
        define variable fld  as IField   no-undo.
        
        define variable PolicyName as char no-undo.
        define variable IdentifyingField as integer no-undo.
        define variable fldName as char no-undo.
        
        do on endkey undo, leave:
            import stream-handle phStream
              tblPolicy
              tName
              tDescription
              tState
              tInstance
              tTableName
              tSourceTableOwner
              tDataAreaName
              tIndexAreaName
              tIdentifyingField            
              tLevel
              tChangeTable
              tChangeTableOwner
              tEncryptPolicy
              tMisc
              fldPolicyCnt             
              .              
                   
            if plReplace then
            do: 
                find ttCdcTablePolicy where ttCdcTablePolicy.Name = tname no-error.
            end.
            
            if not plReplace or not avail ttCdcTablePolicy then 
            do:
               create ttCdcTablePolicy. 
               lnew = true.
            end.        
            assign 
              ttCdcTablePolicy.Name = tName
              ttCdcTablePolicy.Description = tDescription
              ttCdcTablePolicy.TableName = tTableName
              ttCdcTablePolicy.SourceTableOwner = tSourceTableOwner
              ttCdcTablePolicy.DataAreaName = tDataAreaName 
              ttCdcTablePolicy.IndexAreaName = tIndexAreaName 
              ttCdcTablePolicy.IdentifyingField = tIdentifyingField
              ttCdcTablePolicy.Level = tLevel
              ttCdcTablePolicy.State = tState
              ttCdcTablePolicy.ChangeTable = tChangeTable
              ttCdcTablePolicy.ChangeTableOwner = tChangeTableOwner
              ttCdcTablePolicy.EncryptPolicy  = tEncryptPolicy
              ttCdcTablePolicy.Instance = tInstance
             .
            
            currentService = if valid-object(Service)  then Service else TargetService.
            /* if no service then ?? should ideally be fixed when attaching to a context...  */
            if valid-object(currentService) then
            do:                 
                tbl = currentService:GetTable(ttCdcTablePolicy.TableName,ttCdcTablePolicy.SourceTableOwner). 
                if not valid-object(tbl) then 
                     undo, throw new DataContextError("Table " + ttCdcTablePolicy.TableName + " does not exist.").  
                if fldPolicyCnt > 0 then
                do:
                    do ictr = 1 to fldPolicyCnt:
                        import stream-handle phStream
                        fldPolicy
                        PolicyName
                        fldName
                        IdentifyingField                        
                        .
                        if fldPolicy ne "field" then
                            undo, throw new DataContextError("Field Policy count is set to > 0 but missing field policy details").
                        if policyName ne tName then
                            undo, throw new DataContextError("Policy Name in field policy information does not match with table policy name").
                                
                        fld = tbl:Fields:Find(fldName).
                        if not valid-object(fld) then 
                             undo, throw new DataContextError("Field " + fldName + " does not exists in Table " + ttCdcTablePolicy.TableName).
                        SchemaScope:CdcFieldPolicyContext:CreateRow(PolicyName,fldName,IdentifyingField).
                    end. 
                end.        
                /*if fldPolicyCnt eq 0 then
                do:
                    import stream-handle phStream
                    fldPolicy
                    PolicyName
                    fldName
                    IdentifyingField                        
                    .
                    if fldPolicy eq "Field" then
                        undo, throw new DataContextError("Field Policy Count is set to 0 but field policy details found").
                end.  */              
                lok = true.    
            end.
            catch e as Progress.Lang.Error :
                if e:GetMessageNum(1) = 132 then 
                do:
                    if fldPolicyCnt > 0 then
                    do:
                        /* use caret(^) to skip a data value. in this case to skip all the field policy rows. */
                        do ictr = 1 to fldPolicyCnt:
                            import stream-handle phStream
                            ^ ^ ^ ^.                        
                        end. 
                    end.
                    undo, throw new DataAccessError("CDCTablePolicy already exists with policy name " + quoter(tName)).                    
                end.    
                else if not valid-object(tbl) then do:
                    if fldPolicyCnt > 0 then
                    do:
                        /* use caret(^) to skip a data value. in this case to skip all the field policy rows. */
                        do ictr = 1 to fldPolicyCnt:
                            import stream-handle phStream
                            ^ ^ ^ ^.                        
                        end. 
                    end.
                    undo, throw new DataContextError("Table " + quoter(tSourceTableOwner + "." + tName) + " does not exist.").
                end.                 
                undo, throw e.                
            end catch. 
        end.
        if not lok then   
        do:
            if avail ttCdcTablePolicy and lnew then
                delete ttCdcTablePolicy.
        end.    
        else if lok and lnew then     
        do: 
            Count = Count + 1.
            OnRowCreated().
        end.     
        return lok.
        catch e as Progress.Lang.Error :
            if avail ttCdcTablePolicy and lnew then
                delete ttCdcTablePolicy.
            undo, throw e.
        end catch.    
    end method. 


    method private IFetchRequest CreatePartitionRefreshRequest (pcGroup as char):
        define variable tree as IContextTree no-undo.
        define variable msg  as IFetchRequest no-undo.
        tree = new ContextTree().  
        tree:Parse = true.        
        GetChild("partition"):AddTableTo(tree).         
        
        msg = new FetchRequest("Partition",Id,tree:GetReadHandle(),no).
        msg:SetTableQuery("ttPartition","for each ttPartition where ttPartition.CdcTablePolicyName = " + quoter(pcGroup)).
        return msg.
   
    end method.    
    
    method override public void DataRefreshed(presponse as IFetchResponse):
        
        if presponse:Entityname = "partition" 
        and not valid-handle(pResponse:DataHandle:get-buffer-handle(TableHandle:name)) then
            GetChild("partition"):DataRefreshed(presponse).
        else
           super:DataRefreshed(presponse).
/*        define variable cc as character no-undo.          */
/*          for each ttPartitionPolicy :                    */
/*               cc = cc + ttPartitionPolicy.name + chr(10).*/
/*          end.                                            */
/*          message cc                                      */
/*          view-as alert-box.                              */
    end method.   
    
        
    method private logical RefreshTables (pdsChanged as handle):
        define variable hQuery     as handle no-undo.
        define variable hBuffer    as handle no-undo.
        define variable hTableTable    as handle no-undo.
        define variable lok        as logical no-undo.
        define variable lTrack     as logical no-undo.
        define variable lRefresh   as logical no-undo.
        hbuffer = pdsChanged:get-buffer-handle ("ttCdcTablePolicy"). 
        create query hQuery.
        
        hquery:add-buffer (hbuffer).
        hQuery:query-prepare ("for each ttCdcTablePolicy").
        hquery:query-open().
        hquery:get-first.
        loop:
        do while hbuffer:avail:
            /* we need refresh if isallocated is set to true   */  
            if hbuffer:row-state = row-created or hbuffer:row-state = row-modified then
            do:
                SchemaScope:TableContext:UpdateCdcPolicyName(hBuffer::TableName,hBuffer::Name). 
            end.    
            hQuery:get-next.
        end.
        return lok.
    end method.
    
    
   /* refresh tables with policyname                                    */
    method override public void MergeChanges( pResponse as ISaveRequest ):
        RefreshTables(pResponse:DataHandle).
        super:MergeChanges(pResponse).
    end method.

end class.
