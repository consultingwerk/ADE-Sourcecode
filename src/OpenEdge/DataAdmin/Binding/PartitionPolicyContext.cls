/*************************************************************/
/* Copyright (c) 2011-2013 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : Tenant Context/Model
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 03 2010
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
using OpenEdge.DataAdmin.Binding.PartitionPolicyDetailContext.
using OpenEdge.DataAdmin.Binding.PartitionPolicyFieldContext.
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
using OpenEdge.DataAdmin.IPartitionPolicy.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.ITable.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.Message.ISaveRequest.
using OpenEdge.DataAdmin.Message.SaveRequest.
using OpenEdge.DataAdmin.PartitionPolicy.
using OpenEdge.DataAdmin.PartitionPolicySet.
using OpenEdge.DataAdmin.Support.TenantGroupTenantSet.
using OpenEdge.DataAdmin.Support.TenantGroupTenantSet.
using Progress.Lang.*.
using Progress.Json.ObjectModel.JsonObject from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Binding.PartitionPolicyContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/partitionpolicy.i} 
    define buffer bpolicy for ttPartitionPolicy.
    
    /* NOTE: needed for tracking changes*/ 
    define private dataset dsPolicy serialize-name "root" for ttPartitionPolicy.
 
    define temp-table copytable reference-only like ttPartitionPolicy.
      
    define temp-table ttPartitionIdRequest no-undo
        field partitionid as int
        field policyname as char
        index partname as  unique policyname
        index partidx as primary unique partitionid.
        
    define private variable mCreate as logical no-undo.
    define variable mPartitionAfterQuery as handle no-undo.
    define private variable ValidDefaultAllocationList as char init "Immediate,None" no-undo.
    define private variable ValidDefaultAllocationString as char init "~"Immediate~" and ~"None~"" no-undo.
    define private variable SchemaScope as ISchemaScope no-undo.
    define private variable FieldContext as FieldContext no-undo.
    define private variable IndexContext as IndexContext no-undo.
 
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttPartitionPolicy:handle.
    	end get.
   
    define public override property KeyFields as character  no-undo  
        get():
            return "Name". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer bpolicy for ttPartitionPolicy.
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
    
    constructor public PartitionPolicyContext ():
        define variable policyFieldcontext  as PartitionPolicyFieldContext no-undo.
        define variable policydetailcontext as PartitionPolicyDetailContext no-undo.
        define variable localIndexContext   as LocalIndexContext no-undo.
         super ("PartitionPolicy").
        policyFieldcontext = new PartitionPolicyFieldContext().
        policydetailcontext = new PartitionPolicyDetailContext().
        localIndexContext = new LocalIndexContext().
        AddChild(policyFieldcontext).
        AddChild(localIndexContext).
        AddChild(policydetailcontext).
        ExportWithRoot = false.
        CanGenerateCode = true.

    end constructor.

    constructor public PartitionPolicyContext (pScope as ISchemaScope):
        super ("PartitionPolicy",pScope).
        AddChild(pScope:PartitionPolicyFieldContext).
        AddChild(pScope:LocalIndexContext).
        AddChild(pScope:PartitionPolicyDetailContext).
        SchemaScope = pScope.
        ExportWithRoot = false.
        CanGenerateCode = true.
     
    end method.
    
/*    method public override IFetchRequest GetRequest():     */
/*        define variable hDs as handle no-undo.             */
/*        define variable tree as IContextTree no-undo.      */
/*        define variable cntxt as IDataAdminContext no-undo.*/
/*        tree = new ContextTree().                          */
/*        tree:Parse = true.                                 */
/*                                                           */
/*        AddTableTo(tree).                                  */
/*/*        cntxt = getChild("partitionPolicyDetail").*/     */
/*/*        cntxt:AddTreeTo(tree).                    */     */
/*        hDs = tree:GetReadHandle().                        */
/*/*        h = CreateDataSet().*/                           */
/*                                                           */
/*        return new FetchRequest(Name,Id,hDs,no).           */
/*    end method.                                            */
    
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity,IPartitionPolicy)).    
	end method.
	
    method public override character GetJoinFields(parentid as char):
        return "".
    end.
    
    /* detail has different join on server */
    method protected override handle GetRequestDataset():
        /* way too much data to load up front - just load the fields */
        return CreateServerDataset("partitionPolicyFields").  /* final - calls createDataset true */
    end method.
    
    /* override to use Name in JSON import 
    method protected override character GetClientKeyFields():
        return "Name". 
    end method.
      */
      
    method public void FillNewDetails (pcPolicyname as char) :
        define variable request as IFetchRequest   no-undo.
        request = GetNewDetailRequest(pcPolicyname,"","").
        FillNewDetails(request).
    end method. 
    
    /* fill details from data - generate name using substitute base and substitute argstemplate 
        @param - policy name
        @param  pcSubstituteBase  optional base template for detail name to be used in ABL substitute 
        @param  pcSubstituteArgs  optional args  to be used in ABL substitute for detail name
         see substitute param description/format in IPartitionPolicy:AddDetailsFromData(pcSubstituteBase,pcSubstituteArgs) */
    method public void FillNewDetails (pcPolicyname as char,pcSubstituteBase as char,pcSubstituteArgs as char) :
        define variable request as IFetchRequest   no-undo.
        request = GetNewDetailRequest(pcPolicyname,pcSubstituteBase,pcSubstituteArgs).
        FillNewDetails(request).
    end method.  
    
    /* fill details from data - generate name from tokenized template 
        @param - policy name
        @param  pcTemplate - see description/format in IPartitionPolicy:AddDetailsFromData(template) */
    method public void FillNewDetails (pcPolicyname as char,pcTemplate as char) :
        define variable cSubstitute as character no-undo.
        define variable cSubstituteArgs as character no-undo.
        define variable request as IFetchRequest   no-undo.
        ConvertTokensToSubstitute(pcTemplate,output cSubstitute, output cSubstituteArgs).
        request = GetNewDetailRequest(pcPolicyname,cSubstitute,cSubstituteArgs).
        FillNewDetails(request).
    end method.  
    
    method protected void FillNewDetails( request as IFetchRequest   ):
        SchemaScope:PartitionPolicyDetailContext:FillData(request).
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
    method protected IFetchRequest GetNewDetailRequest(pcPolicyname as char,pcSubstituteBase as char,pcSubstituteArgs as char) :
        define variable req as IFetchRequest no-undo.
        define variable h as handle no-undo.
        define variable cflds as character extent no-undo.
        define variable i as integer no-undo.    
        define variable cquery as character no-undo.
        define variable cDetailnameTemplate as character no-undo.
        define variable cDetailField as character no-undo.
        if pcPolicyname = ? then 
            undo, throw new UnknownValueError("GetNewDetailRequest","Policyname").
        if this-object:Find(pcPolicyname) then
        do:
            h = CreateServerDataset().
            req = new FetchRequest(this-object:Name,Id,h,no).
            
            if ttPartitionPolicy.TableName = "" or ttPartitionPolicy.tableName  = ? then
               undo, throw new UnsupportedOperationError("Cannot request new details for a policy with no table").
               
            cQuery = "where ttPartitionPolicy.Name = "      + quoter(ttPartitionPolicy.Name) 
                   + " and  ttPartitionPolicy.TableName = " + quoter(ttPartitionPolicy.TableName) 
                   + " and  ttPartitionPolicy.HasRange = "  + quoter(ttPartitionPolicy.HasRange).
                   
            /* if not passed check if loaded from json */
            if pcSubstituteBase = "" or pcSubstituteBase = ? then
            do:    
                cDetailnameTemplate =  ttPartitionPolicy.DetailNameTemplate.
                if cDetailnameTemplate > "" then
                do:
                    ConvertTokensToSubstitute(cDetailnameTemplate,output pcSubstituteBase, output pcSubstituteArgs ).
                end.      
                else do:
                    pcSubstituteBase = "&1-&2".
                    pcSubstituteArgs = "PartitionPolicyName,Number".
                end.   
            end.
            /* add name temaplate substititute to query if specified */
            do i = 1 to num-entries(pcSubstituteArgs):
                cDetailField = entry(i,pcSubstituteArgs).
                if(cDetailField = "Number") then
                    cDetailField  = "ttPartitionPolicyDetail.Number".
                else  
                    cDetailField = SchemaScope:PartitionPolicyDetailContext:ColumnSource(cDetailField).
                
                entry(i,pcSubstituteArgs) = cDetailField.
            end.
            cQuery = cQuery 
                   + " and  ttPartitionPolicy.DetailNameSubstituteBase = " + quoter(pcSubstituteBase)         
                   + " and  ttPartitionPolicy.DetailNameSubstituteNames = " + quoter(pcSubstituteArgs).
          
            cflds = SchemaScope:PartitionPolicyFieldContext:GetFieldNames(pcPolicyname).
            if extent(cflds) = ? then
                undo, throw new UnsupportedOperationError("Cannot request new details for a policy with no fields").
            
            do i = 1 to extent(cflds):
                cQuery = cQuery + " and ttPartitionPolicyField.FieldName = " +  quoter(cflds[i]) .
            end.                
            req:SetTableRequestType("ttPartitionPolicyDetail","NEW").
            /* somewhat hacky - works like a charm due to data source columnExpression 
              - the query is used to pass request parameters. Taking advantage of the existing query passing and parsing 
              mechanisms. It is not used as a query on the server (the fields may not exist in the tt) .  */ 
            
            req:SetTableQuery("ttPartitionPolicyDetail",cQuery).
            return req.
        end.
        undo, throw new IllegalArgumentError("GetNewDetailRequest called with invalid policy name: " + quoter(pcPolicyname)).
    end method.   
    
    /*overide to read DetailNameTemplate which is hidden (and not persisted - only used in  adddetailsfromdata)*/
    method protected override void ReadRow(pjson as JsonObject,pcExceptColumns as char):
        define variable lhidden as logical no-undo.
        define variable hFld as handle no-undo.
        hFld = TableHandle:default-buffer-handle:buffer-field ("DetailNameTemplate").
        lhidden = hFld:serialize-hidden.
        if lhidden then
        do:
            hFld:serialize-name="detailNameTemplate".
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
/*            if valid-object(Service) and valid-object(copytable.Entity) then*/
/*            do:                                                             */
/*                ValidateTenant(cast(copytable.Entity,ITenant)).             */
/*            end.                                                            */
            do on error undo, throw:
                find bpolicy where bpolicy.name = copytable.name no-error.
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail bpolicy then
                do:
                    create bpolicy.
                    bpolicy.name = copytable.name.               
                end.    
                catch e as Progress.Lang.Error :
                    delete bpolicy.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("PartitionPolicy",e).
                    else 
                       dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        lTrack = temp-table ttPartitionPolicy:tracking-changes.
        temp-table ttPartitionPolicy:tracking-changes = true.
        for each copytable:
            create ttPartitionPolicy.    
            Count = Count + 1.
            buffer-copy copytable to ttPartitionPolicy.    
            OnRowCreated().
        end.
        temp-table ttPartitionPolicy:tracking-changes = lTrack.
    end method.  
	
	/** fires after change - validation should have been done */
	method protected override void ValueChanged(pFieldName as char,pcOldValue as char,pNewValue as char).        
        define variable cntxt as PartitionPolicyDetailContext no-undo. 
        super:ValueChanged(pfieldname,pcoldvalue,pNewValue).
        /* if new tenant then the partitions must be updated with default values */
        if pFieldName begins "Default" 
        and (buffer ttPartitionPolicy:row-state = row-created 
             /* rootid = rowid implies new tenant */
             or RootId = rowid(ttPartitionPolicy) ) then
        do: 
            cntxt = cast(getChild("PartitionPolicyDetails"),PartitionPolicyDetailContext).
            cntxt:UpdatePartitionDefault(ttPartitionPolicy.name,pFieldName,pcOldValue,pNewValue).
        end.
    end method.
	
	method private character GetCreateError(policy as IPartitionPolicy):
        return this-object:GetCreateError(cast(policy,IDataAdminElement),policy:Name). 
    end method.
 
    
    method protected override void ValidateBuffer(phPolicy as handle):
        define variable hBefore as handle no-undo.
        define variable cName as character no-undo.
        if phPolicy:row-state = row-modified then
        do:
            cName = phPolicy::name.
            if cname = ? then cName = "<unknown>".
            hBefore = phPolicy:before-buffer.
            hbefore:find-by-rowid(phPolicy:before-rowid).
            if phPolicy::HasRange <> hBefore::HasRange then
               undo, throw new CreateOnlyPropertyError(Name,cName,"HasRange").
               
            /* OEM 449- allow rename   */
            /*if phPolicy::Name <> hBefore::Name then
               undo, throw new ReadOnlyPropertyError(Name,phPolicy::Name,"Name").*/
        end. 
        else if phPolicy:row-state = row-created then
        do:
            if phPolicy::IsCompositeReadOnly = true then
            do:
                cName = phPolicy::name.
                if cname = ? then cName = "<unknown>".
                undo, throw new ReadOnlyPropertyError("PartitionPolicy",cName,"IsCompositeReadOnly",CreateReadOnlyError).
            end.
        end.          
    end method.      
    
	method private void ValidatePolicy(policy as IPartitionPolicy):
	    define variable validateError as DataContextError no-undo.
	    define variable lError as logical no-undo.
        define variable cErr as character extent 8 no-undo.
        define variable i as integer no-undo.   
        
            if not valid-object(policy:DefaultDataArea) then
            do:
                cErr[1] = "DefaultDataArea is undefined.". 
                lerror = true.
            end.
            else if valid-object(Service) and policy:DefaultDataArea:Service <> Service then
            do:
                cErr[1] = "DefaultDataArea " + quoter(policy:DefaultDataArea:Name) + " does not exist in service.".              
                lerror = true.
            end.
                 
            if not valid-object(policy:DefaultIndexArea) then
            do:
                cErr[2] = "DefaultIndexArea is undefined". 
                lerror = true.
            end.
            else if valid-object(Service) and policy:DefaultIndexArea:Service <> Service then
            do:
                cErr[2] = "DefaultIndexArea " + quoter(policy:DefaultIndexArea:Name) + " does not exist in service.".              
                lerror = true.
            end.
            
            if not valid-object(policy:DefaultLobArea) then
            do:
                cErr[3] = "DefaultLobArea is undefined". 
                lerror = true.
            end.
            else if valid-object(Service) and policy:DefaultDataArea:Service <> Service then
            do:
                cErr[3] = "DefaultLobArea " + quoter(policy:DefaultDataArea:Name) + " does not exist in service.".              
                lerror = true.
            end.
            
            if policy:DefaultAllocation = "" or policy:DefaultAllocation = ? then
            do:
                cErr[4] = "DefaultAllocation cannot be blank.".              
                lerror = true.
            end.
            else if lookup(policy:DefaultAllocation,ValidDefaultAllocationList) = 0 then
            do:
                cErr[4] = quoter(policy:DefaultAllocation) + " is not a valid DefaultAllocation value. Valid values are " + ValidDefaultAllocationString + ".".              
                lerror = true.
            end. 
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
        if pName = "details" then 
        do:
            return GetChild("partitionPolicyDetails").
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
/*	method public override FilteredContext CreateFilteredContext( pparent as character, pkey as character, pReq as IRequestInfo ):*/
/*        if pparent = "tenantGroups" then                                                                                       */
/*        do:                                                                                                                    */
/*/*            return new TenantGroupTenantQuery(this-object,pkey,pReq).*/                                                      */
/*        end.                                                                                                                   */
/*        return super:CreateFilteredContext(pparent, pkey,pReq).                                                                */
/*                                                                                                                               */
/*    end method.                                                                                                                */
/*	                                                                                                                               */
/*	method override protected IDataAdminCollection CreateCollection(pparent as char,pcntxt as FilteredContext):*/
/*        define variable cntxt as IDataAdminContext no-undo.                                                 */
/*        case pparent:                                                                                       */
/*            when "tenantGroups" then                                                                        */
/*                return new TenantGroupTenantSet(pcntxt).                                                    */
/*            otherwise                                                                                       */
/*                return super:CreateCollection(pparent,pcntxt).                                              */
/*        end.                                                                                                */
/*    end method.                                                                                             */
    
/*    method public override character  GetChildQuery(parentid as char,pcKeyValue as char).*/
/*        define variable cQuery as character no-undo.                                     */
/*                                                                                         */
/*        case parentid:                                                                   */
/*            when "tenantGroups" then                                                     */
/*            do:                                                                          */
/*                cQuery = GetServerChildQuery(parentid,pcKeyValue)                        */
/*                       + " where ttTenant.Name = ttTenantGroupMember.TenantName".        */
/*                cQuery = left-trim(cQuery).                                              */
/*                entry(1,cQuery," ") = "preselect".                                       */
/*                                                                                         */
/*                return cQuery.                                                           */
/*            end.                                                                         */
/*        end.                                                                             */
/*        return super:GetChildQuery(parentid,pcKeyValue).                                 */
/*                                                                                         */
/*    end method.                                                                          */
/*                                                                                         */
/*    method public override character  GetServerChildQuery(parentid as char,pcKeyValue as char).                     */
/*        case parentid:                                                                                              */
/*            when "tenantGroups" then                                                                                */
/*            do:                                                                                                     */
/*                /* the left hand sisnde of the join is not transformed on server                                    */
/*                   we manage the server relation in GetQueryRequest by defining a join in the request dataset()   */*/
/*                return  "for each ttTenantGroupMember where ttTenantGroupMember.TenantGroupName "                   */
/*                            + " = "                                                                                 */
/*                            + quoter(pcKeyValue)                                                                    */
/*                            + ", each ttTenant".                                                                    */
/*             end.                                                                                                   */
/*         end.                                                                                                       */
/*         return super:GetserverChildQuery(parentid,pcKeyValue).                                                     */
/*                                                                                                                    */
/*    end method.                                                                                                     */
    
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
    
	method public void CreateRow(policy as IPartitionPolicy):
	    define variable validateError as DataContextError no-undo.
        define variable ltrack as logical no-undo.
        
        lTrack = temp-table ttPartitionPolicy:tracking-changes .
	    temp-table ttPartitionPolicy:tracking-changes = true.
	    if valid-object(Service) then
	       ValidatePolicy(policy).
	    
	    do on error undo, throw: 
	        create ttPartitionPolicy.
            assign 
                ttPartitionPolicy.Name = policy:name
                 ttPartitionPolicy.TableName = policy:Table:name
                 ttPartitionPolicy.Entity = policy
                ttPartitionPolicy.hasRange = hasRange
                ttPartitionPolicy.Description =  policy:Description.
/*                ttPartitionPolicy.IsDataEnabled    =  policy:IsDataEnabled*/
/*                ttPartitionPolicy.IsAllocated =  policy:IsAllocated.      */
                if valid-object(policy:DefaultDataArea) then
                    ttPartitionPolicy.DefaultDataAreaName  = policy:DefaultDataArea:Name.
                if valid-object(policy:DefaultIndexArea) then
                    ttPartitionPolicy.DefaultIndexAreaName = policy:DefaultIndexArea:Name.
                if valid-object(policy:DefaultLobArea) then
                    ttPartitionPolicy.DefaultLobAreaName   = policy:DefaultLobArea:Name.
                ttPartitionPolicy.DefaultAllocation    = policy:DefaultAllocation.
            Count = Count + 1.
            OnRowCreated().      
            catch e as Error:  
                delete  ttPartitionPolicy.
                undo, throw new DataContextError(GetCreateError(policy),"PartitionPolicy",e).  
            end catch.  
        end.
        finally:
            temp-table ttPartitionPolicy:tracking-changes = lTrack.        		
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
        return can-find(ttPartitionPolicy where ttPartitionPolicy.name = name).            
    end.    
     
    method public override logical Find(name as character):
        find ttPartitionPolicy where ttPartitionPolicy.name = name no-error.
        return avail ttPartitionPolicy.            
    end.    
 
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):
        return new PartitionPolicySet(cntxt). 
    end method.
    
    method protected override IDataAdminElement CreateEntity(req as IRequestInfo):
        return new PartitionPolicy(this-object,req).
    end method.
    
    
    /*
    method public ISaveRequest GetCreateRequest():
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
        SaveDataset = CreateDataset("domains").       
        hchanges = GetChanges(SaveDataset).
         
        savemsg = new SaveRequest(Name,Id,hchanges).
/*        mCreate = true.*/
        return savemsg.
    end method.
    
    /* used by CreateTenant(s) to perform a second transaction */
    method public ISaveRequest GetPartitionSaveRequest():
        define variable hchanges as handle no-undo.
        define variable savemsg as ISaveRequest no-undo.
        SaveDataset = CreateDataset("partitions").       
        hchanges = GetChanges(SaveDataset).
         
        savemsg = new SaveRequest(Name,Id,hchanges).
/*        mCreate = true.*/
        return savemsg.
    end method.
    */
    
    /*
    /* Called from merge with the changes returned from server to keep track of 
       which partitions that will need to be refreshed. */        
    
    method private logical CreatePartionRefreshIds (pdsChanged as handle):
        define variable hQuery     as handle no-undo.
        define variable hBuffer    as handle no-undo.
        define variable hBefore    as handle no-undo.
        define variable lok        as logical no-undo.
        define variable lRefresh   as logical no-undo.
        define variable hPartition as handle no-undo.
        
        hbuffer = pdsChanged:get-buffer-handle ("tttenant"). 
       
        create query hQuery.
        
        hquery:add-buffer (hbuffer).
        hQuery:query-prepare ("for each ttTenant").
        hquery:query-open().
        hquery:get-first.
        do while hbuffer:avail:
            if hbuffer:row-state = row-created then
                lRefresh = true.
            else if hbuffer:row-state = row-modified then
            do:     
                hBefore = hbuffer:before-buffer.
                hbefore:find-by-rowid(hBuffer:before-rowid). 
                if hBuffer::isAllocated and hBefore::isAllocated = false then 
                   lRefresh = true.  
            end.            
            if lRefresh then 
            do:
                create ttPartitionIdRequest.
                ttPartitionIdRequest.PartitionId = hBuffer::Id.
                ttPartitionIdRequest.Tenantname = hBuffer::name.
            end.
            hQuery:get-next.
            lok = true.
        end.
    end method.
  
    method public logical HasPartitionChanges():
        define variable hBuffer as handle no-undo.
        hbuffer = GetChild("partitions"):Tablehandle:default-buffer-handle. 
        return hBuffer:before-buffer:table-handle:has-records. 
    end method.     
      */
    /*
    method public logical NeedPartitionRefresh():
        return can-find(first ttPartitionIdRequest).        
    end method.     
    
    method private logical EmptyPartitionRefresh():
        empty temp-table ttPartitionIdRequest.        
    end method.     
      */
      /*
    method private void DeletePartitionsBeforeRequest ():
        define variable hQuery     as handle no-undo.
        define variable hBuffer    as handle no-undo.
        create query hQuery.
        
         /* now workaround the fact that fill cannot replace (even if it should? ) */
        hbuffer = GetChild("partitions"):Tablehandle:default-buffer-handle. 
        hquery:set-buffers (buffer  ttPartitionIdRequest:handle).
        hquery:add-buffer (hbuffer).
        hQuery:query-prepare ("for each ttPartitionIdRequest, each ttPartition of ttPartitionIdRequest").
        hquery:query-open().
        hquery:get-first.
        
/*        hBuffer:table-handle:tracking-changes = false.*/
        do while hbuffer:avail:
            hBuffer:buffer-delete ().
            hQuery:get-next.
        end.    
/*        hBuffer:table-handle:tracking-changes = true.*/
        delete object hQuery.
      
    end method.    
      */
      /*
    method private IFetchRequest CreatePartitionRefreshRequest ():
        define variable tree as IContextTree no-undo.
        define variable msg  as IFetchRequest no-undo.
        tree = new ContextTree().  
        tree:Parse = true.   
        tree:SetHandle("requests",buffer ttPartitionIdRequest:handle).    
        GetChild("partitions"):AddTableTo(tree).         
        msg = new FetchRequest("Partition",Id,tree:GetReadHandle()).
   
        return msg.
   
    end method.    
    */
    
    method protected override char FindExpression(c as char):
        return "ttPartitionPolicy.Name = " + quoter(c).
    end method.
    
    method private void DeletePartitionAfterQuery():
        delete object mPartitionAfterQuery.
    end method.
    
    method public override void SerializeRow(phStream as handle):
        export stream-handle phStream
            ttPartitionPolicy.Name
            ttPartitionPolicy.TableName
            ttPartitionPolicy.Description
            ttPartitionPolicy.DefaultDataAreaName
            ttPartitionPolicy.DefaultIndexAreaName 
            ttPartitionPolicy.DefaultLobAreaName
            ttPartitionPolicy.DefaultAllocation
            ttPartitionPolicy.HasRange 
            ttPartitionPolicy.FieldNames
            /*** end 11.4 **/   
 /* new in 11.5 - not exported since it requires details in same transaction  */
/*            ttPartitionPolicy.IsCompositeReadOnly*/
            /*** end 11.5 **/  
            .
    end method. 
    
    method protected override logical DeserializeRow(phStream as handle, plReplace as log):
        define variable i as integer no-undo.
        define variable lok as logical no-undo.
        define variable lnew as logical no-undo.
        define variable tname like ttPartitionPolicy.Name no-undo.
        define variable tTableName like ttPartitionPolicy.TableName no-undo.
        define variable tDefaultDataAreaName like ttPartitionPolicy.DefaultDataAreaName no-undo.
        define variable tDefaultIndexAreaName like ttPartitionPolicy.DefaultIndexAreaName no-undo.
        define variable tDefaultLobAreaName like ttPartitionPolicy.DefaultLobAreaName no-undo.
        define variable tDefaultAllocation like ttPartitionPolicy.DefaultAllocation no-undo.
        define variable tFieldNames like ttPartitionPolicy.FieldNames no-undo.
        define variable tHasRange like ttPartitionPolicy.HasRange no-undo.
/* future - requires details in same trans  
        define variable tIsCompositeReadOnly like  ttPartitionPolicy.IsCompositeReadOnly no-undo.*/
        define variable tDescription like ttPartitionPolicy.Description no-undo.
        define variable currentService as IDataAdminService  no-undo.
        define variable tbl as ITable  no-undo.
        define variable fld  as IField   no-undo.
        
        do on endkey undo, leave:
            import stream-handle phStream
              tName
              tTableName
              tDescription
              tDefaultDataAreaName
              tDefaultIndexAreaName
              tDefaultLobAreaName
              tDefaultAllocation
              tHasRange
              tFieldNames
              /** 11.5 nothing...  */
             /*   to be true this must handle details in same transaction   
              tIsCompositeReadOnly*/
              .
            if plReplace then
            do: 
                find ttPartitionPolicy where ttPartitionPolicy.name = tname no-error.
            end.
            
            if not plReplace or not avail ttPartitionPolicy then 
            do:
               create ttPartitionPolicy. 
               lnew = true.
            end.        
            assign 
              ttPartitionPolicy.Name = tName
              ttPartitionPolicy.TableName = tTableName
              ttPartitionPolicy.DefaultDataAreaName = tDefaultDataAreaName 
              ttPartitionPolicy.DefaultIndexAreaName = tDefaultIndexAreaName 
              ttPartitionPolicy.DefaultLobAreaName = tDefaultLobAreaName 
              ttPartitionPolicy.DefaultAllocation = tDefaultAllocation 
              ttPartitionPolicy.FieldNames = tFieldNames
              ttPartitionPolicy.HasRange = tHasRange
/*   see above           ttPartitionPolicy.IsCompositeReadOnly = tIsCompositeReadOnly*/
             .
             
            currentService = if valid-object(Service)  then Service else TargetService.
            /* if no service then ?? should ideally be fixed when attaching to a context...  */
            if valid-object(currentService) then
            do: 
                /* we're paying a heavy price for the decision to have datatype in the json 
                   only needed in case of export... not used in OO layer  
                   @todo disallow export when dirty..?.   
                   At some point this is needed anyways, so maybe not as expensive as it looks.. 
                   we may possibly add validation in business logic further in and the second call will be cheaper 
                 */ 
                tbl = currentService:GetTable(ttPartitionPolicy.TableName). 
                if not valid-object(tbl) then 
                     undo, throw new DataContextError("Table " + ttPartitionPolicy.TableName + " does not exist.").  
                    
                do i = 1 to extent(ttPartitionPolicy.FieldNames):
                     if ttPartitionPolicy.FieldNames[i] > "" then 
                     do: 
                         fld = tbl:Fields:Find(ttPartitionPolicy.FieldNames[i]).
                         if not valid-object(fld) then 
                             undo, throw new DataContextError("Field " + ttPartitionPolicy.FieldNames[i] + " does not exist in Table " + ttPartitionPolicy.TableName).  
                         SchemaScope:PartitionPolicyFieldContext:CreateRow(ttPartitionPolicy.Name,i,fld).
/*                        SchemaScope:PartitionPolicyFieldContext:CreateRow(ttPartitionPolicy.Name,ttPartitionPolicy.TableName,ttPartitionPolicy.FieldNames[i]).*/
                         ttPartitionPolicy.NumFields = i.
                     end.
                     else /* leave - no point looping any more */
                         leave.
                end.  
                lok = true.    
            end.
            catch e as Progress.Lang.Error :
                undo, throw e.
            end catch. 
        end.
        if not lok then   
        do:
            if avail ttPartitionPolicy and lnew then
                delete ttPartitionPolicy.
        end.    
        else if lok and lnew then     
        do: 
            Count = Count + 1.
            OnRowCreated().
        end.     
        return lok.
        catch e as Progress.Lang.Error :
            if avail ttPartitionPolicy and lnew then
                delete ttPartitionPolicy.
            undo, throw e.
        end catch.    
    end method. 
    
/*    method private void CreatePartitionAfterQuery(pbufferHandle as handle):*/
/*        define variable hbuffer as handle no-undo.                         */
/*        create query mPartitionAfterQuery.                                 */
/*        mPartitionAfterQuery:add-buffer(pbufferHandle).                    */
/*    end method.                                                            */
    
/*    /** called from merge to check if allocationstate of a table changed   */                         */
/*    method private logical PartitionsNeedRefresh(pcTenant as char):                                   */
/*        define variable hbuffer as handle no-undo.                                                    */
/*        define variable hbefore as handle no-undo.                                                    */
/*        hBuffer = mPartitionAfterQuery:get-buffer-handle (1).                                         */
/*        hbefore  = hBuffer:before-buffer.                                                             */
/*        /* check modified rows for allocation changes (new are refreshed since parent is refreshed) */*/
/*        mPartitionAfterQuery:query-prepare(                                                           */
/*           "for each ttPartition where ttPartition.TenantName = " + quoter(pcTenant)                  */
/*                                    + " and row-state(ttPartition) = row-modified"                    */
/*                                    + " and ttPartition.ObjectType = 'Table'").                       */
/*        mPartitionAfterQuery:query-open().                                                            */
/*        mPartitionAfterQuery:get-first.                                                               */
/*        do while hBuffer:avail:                                                                       */
/*            hBefore:find-by-rowid(hBuffer:before-rowid).                                              */
/*            if hBuffer::AllocationState <> hBefore::AllocationState then                              */
/*                return true.                                                                          */
/*            mPartitionAfterQuery:get-next.                                                            */
/*        end.                                                                                          */
/*        return false.                                                                                 */
/*    end method.                                                                                       */
    
/*    method private logical RefreshPartitions (pdsChanged as handle):*/
/*        define variable hQuery     as handle no-undo.                                        */
/*        define variable hBuffer    as handle no-undo.                                        */
/*        define variable hBefore    as handle no-undo.                                        */
/*        define variable lok        as logical no-undo.                                       */
/*        define variable lTrack     as logical no-undo.                                       */
/*        define variable lRefresh   as logical no-undo.                                       */
/*        define variable hPartition as handle no-undo.                                        */
/*        define variable msg as IFetchRequest no-undo.                                        */
/*                                                                                             */
/*        hbuffer = pdsChanged:get-buffer-handle ("ttPartitionPolicy").                        */
/*        hPartition = pdsChanged:get-buffer-handle ("ttPartition").                           */
/*        if valid-handle(hPartition) then                                                     */
/*            CreatePartitionAfterQuery(hPartition).                                           */
/*        create query hQuery.                                                                 */
/*                                                                                             */
/*        hquery:add-buffer (hbuffer).                                                         */
/*        hQuery:query-prepare ("for each ttPartitionPolicy").                                 */
/*        hquery:query-open().                                                                 */
/*        hquery:get-first.                                                                    */
/*        loop:                                                                                */
/*        do while hbuffer:avail:                                                              */
/*            lRefresh = false.                                                                */
/*            if hBuffer:row-state = 0 then                                                    */
/*            do:                                                                              */
/*               /* @todo remove no-error and throw something  */                              */
/*               find ttPartitionPolicy where ttPartitionPolicy.name = hbuffer::name no-error. */
/*               if avail ttPartitionPolicy then                                               */
/*               do:                                                                           */
/*                   if ttPartitionPolicy.isallocated <> hbuffer::IsAllocated then             */
/*                   do:                                                                       */
/*                       lTrack = temp-table ttPartitionPolicy:tracking-changes.               */
/*                       temp-table ttPartitionPolicy:tracking-changes = false.                */
/*                       assign ttPartitionPolicy.isallocated = hbuffer::IsAllocated.          */
/*                       temp-table ttPartitionPolicy:tracking-changes = lTrack.               */
/*                   end.                                                                      */
/*               end.                                                                          */
/*            end.                                                                             */
/*            /* we need refresh if isallocated is set to true   */                            */
/*            else if hbuffer:row-state = row-modified then                                    */
/*            do:                                                                              */
/*                hBefore = hbuffer:before-buffer.                                             */
/*                hbefore:find-by-rowid(hBuffer:before-rowid).                                 */
/*                if hBuffer::isAllocated and hBefore::isAllocated = false then                */
/*                do:                                                                          */
/*                   /** could be imporved by only doing the request of there are partitions */*/
/*                    lRefresh = true.                                                         */
/*                end.                                                                         */
/*            end.                                                                             */
/*            else if hbuffer:row-state = row-created then                                     */
/*            do:                                                                              */
/*                lRefresh = true.                                                             */
/*            end.                                                                             */
/*                                                                                             */
/*            if not lRefresh and valid-handle(hPartition) then                                */
/*            do:                                                                              */
/*                lRefresh = PartitionsNeedRefresh(hbuffer::name).                             */
/*            end.                                                                             */
/*                                                                                             */
/*            if lRefresh then                                                                 */
/*            do:                                                                              */
/*                msg = CreatePartitionRefreshRequest(hBuffer::name).                          */
/*                FetchData(msg).                                                              */
/*                lok = true.                                                                  */
/*            end.                                                                             */
/*            hQuery:get-next.                                                                 */
/*        end.                                                                                 */
/*        return lok.                                                                          */
/*    end method.                                                                              */

    method private IFetchRequest CreatePartitionRefreshRequest (pcGroup as char):
        define variable tree as IContextTree no-undo.
        define variable msg  as IFetchRequest no-undo.
        tree = new ContextTree().  
        tree:Parse = true.        
        GetChild("partitions"):AddTableTo(tree).         
        
        msg = new FetchRequest("Partition",Id,tree:GetReadHandle(),no).
        msg:SetTableQuery("ttPartition","for each ttPartition where ttPartition.PolicyName = " + quoter(pcGroup)).
        return msg.
   
    end method.    
    
    method override public void DataRefreshed(presponse as IFetchResponse):
        
        if presponse:Entityname = "partition" 
        and not valid-handle(pResponse:DataHandle:get-buffer-handle(TableHandle:name)) then
            GetChild("partitions"):DataRefreshed(presponse).
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
        hbuffer = pdsChanged:get-buffer-handle ("ttPartitionPolicy"). 
        create query hQuery.
        
        hquery:add-buffer (hbuffer).
        hQuery:query-prepare ("for each ttPartitionPolicy").
        hquery:query-open().
        hquery:get-first.
        loop:
        do while hbuffer:avail:
            /* we need refresh if isallocated is set to true   */  
            if hbuffer:row-state = row-created or hbuffer:row-state = row-modified then
            do:
                SchemaScope:TableContext:UpdatePolicyName(hBuffer::TableName,hBuffer::name).
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

	 
    
    
/*	method public void showtables():                              */
/*        define variable cc as character no-undo.               */
/*        for each ttTenant:                                     */
/*            cc = cc + ttTenant.Name                            */
/*            + " rowstate "  + string(buffer ttTenant:row-state)*/
/*            + chr(10).                                         */
/*        end.                                                   */
/*                                                               */
/*        if not session:batch-mode then                         */
/*        do:                                                    */
/*            message cc view-as alert-box.                      */
/*        end.                                                   */
/*    end method.                                                */
/*	                                                               */
end class.
