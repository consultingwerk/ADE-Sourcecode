/*************************************************************/
/* Copyright (c) 2010-2013,2015 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Aug 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.DataAdminContext.
using OpenEdge.DataAdmin.Binding.Factory.IContextFactory.
using OpenEdge.DataAdmin.Binding.Factory.IIdentityScope.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IDataAdminModel.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.Query.DomainUserQuery.
using OpenEdge.DataAdmin.Binding.Query.FilteredContext.
using OpenEdge.DataAdmin.Binding.Query.UserQuery.
using OpenEdge.DataAdmin.Binding.ServiceAdapter.
using OpenEdge.DataAdmin.Binding.UserContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.DataContextError.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IDataAdminCollection.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IDomain.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.IUser.
using OpenEdge.DataAdmin.Message.IFetchResponse.
using OpenEdge.DataAdmin.Message.ITableResponse.
using OpenEdge.DataAdmin.User.
using OpenEdge.DataAdmin.UserSet.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.UserContext inherits DataAdminContext implements IDataAdminContext: 
    
    {daschema/user.i} 
    define private dataset dsUser serialize-name "root" for ttUser.
    define buffer buser for ttUser.
    define temp-table copytable reference-only like ttUser .  
    
    define private variable mRefresh as logical no-undo.
    
    define public property ContextFactory as IContextFactory  no-undo 
        get():
            return cast(ContextScope,IContextFactory) .
        end get.
    
	define public override property TableHandle as handle no-undo 
    	get():
    		return temp-table ttUser:handle.
    	end get.
    
    define public override property KeyFields as character  no-undo  
        get():
            return "Id". 
        end.   
    
    define public override property Count as integer init ? no-undo  
        get(): 
            define buffer buser for ttUser.
            
            if Count = ? then
            do:
                
                Count = 0.
                for each buser:
                    Count = Count + 1.
                end. 
            end.    
            return Count.
        end.
        public set.
    
    constructor public UserContext ():
        super ("User").
    end constructor.
        
/*	constructor public UserContext ( service as DataAdminService):*/
/*		super ("User",service).                                      */
/*	end constructor.                                              */
     
    constructor public UserContext ( pscope as IIdentityScope):
        super ("User",pScope). 
        
    end constructor.
    
        /*   temporary until all sub classes are using createDataset  */
    method override protected handle InitDataset ():
        return dataset dsUser:handle. 
    end method.
    
	method public override character GetJoinFields(parentid as char):
        case parentid:
            when "tenants" then
                return "Name,TenantName".
            when "tenants.id" then
                return "Id,TenantId".    
            when "domains" then
                return "Name,DomainName".
        end.
    end.
    
    method public override character GetServerJoinFields(parentid as char):
        case parentid:
            when "tenants" then
                return "Id,TenantId".
        end.
        return super:GetServerJoinFields(parentid).
    end.
    
    
    /* override to use Name in JSON import  
    method protected override character GetClientKeyFields():
        return "Name,DomainName". 
    end method.
    */
    /*
    method public override character GetServerJoinFields(parentid as char):
        case parentid:
            when "tenants" then
                return "Id,TenantId".
        end.
        return super:GetServerJoinFields(parentid).
    end.
    */
	method public override void CreateRow(entity as IDataAdminElement):
	    /* the default syserror has all info */
	    CreateRow(cast(entity,IUser)).    
	end method.

    method protected override void CopyTable(cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
          
        hTbl = cntxt:TableHandle.
        
        CopyTable(table-handle hTbl by-reference). 
        Loaded = false.
    end method.    
    
    method protected override void CopyTableForParent(piRow as IRow,cntxt as IDataAdminModel):
        define variable hTbl as handle no-undo.
        hTbl = cntxt:TableHandle.
        case piRow:SerializeName:         
           when "tenants" then 
           do:
               CopyTable(table-handle hTbl by-reference,"T",piRow:KeyValue).
           end.
           when "domains" then
               CopyTable(table-handle hTbl by-reference,"D",piRow:KeyValue). 
           otherwise 
               undo, throw new IllegalArgumentError("UserContext:CopyTableForParent called with parent " + quoter(piRow:SerializeName)).        
        end.
        
        Loaded = false.
    end method.    
    
    method private void CopyTable(input table copytable):
          CopyTable(table copytable by-reference,"","").
    end method.
    
	method private void CopyTable(input table copytable,pcType as char,pcValue as char):
	    define variable dataerror as DataContextError no-undo.    
	    define variable cDomain as character no-undo.
	    define variable dmn as IDomain no-undo.
        for each copytable on error undo, throw:  
            
            if pcType = "T" then
            do:
                if copytable.tenantname > "" and copytable.tenantname <> pcValue then 
                       undo, throw new IllegalArgumentError(
                              "User " + copytable.name + " belongs to another Tenant." ).
                
                if copytable.DomainName = "" and copytable.tenantname <> "Default" then 
                    undo, throw new IllegalArgumentError(
                              "User " + copytable.name + " has no Domain." ).
                
                /* need to read domain for save 
                   - we use the domain relation in the dataset 
                  (it is possible to change CreateDataset to have users right under
                   tenant, some work likely needed to use tenantname field -
                   - could make it easier to move validation to from create to save   ) */
                if valid-object(Service) then 
                do:
                    dmn = service:getDomain(copytable.DomainName). 
                    if not valid-object(dmn) then 
                        undo, throw 
                           new IllegalArgumentError(
                              "User " + copytable.name + " Domain " +  copytable.DomainName  + " does not exist.").
                     
                     if dmn:Tenant:name <> pcValue then
                        undo, throw 
                           new IllegalArgumentError(
                              "User " + copytable.name + " Domain " +  copytable.DomainName  + " belongs to another Tenant.").
             
                end.
                cDomain = copytable.DomainName.
            end.
            if pcType = "D" then
            do:
                if copytable.domainname > "" and copytable.domainname <> pcValue then 
                    undo, throw new IllegalArgumentError(
                              "User " + copytable.name + " belongs in another Domain." ).
           
               cDomain = if pctype = "D" then pcValue
                         else copytable.DomainName.
            end.
            do on error undo, throw:
                
                find buser where buser.name = copytable.name
                                 and buser.DomainName = cDomain no-error.
                 
                /* force error message 
                   - DataError will transform progress message 
                     to "entity" message */
                if avail buser then
                do:
                    create bUser.
                    buser.name = copytable.name.
                    buser.domainname = cDomain.               
                end.    
                catch e as Progress.Lang.Error :
                  
                    delete bUser.
                    if not valid-object(DataError) then 
                        dataError = new DataContextError("User",e).
                    else 
                       dataError:AddMessage(e).             		
                end catch. 
            end.             
        end.    
        
        if valid-object(dataError) then
            undo, throw dataError. 
        temp-table ttUser:tracking-changes = true.
        for each copytable:
            create ttuser.    
            Count = Count + 1.
            buffer-copy copytable to ttuser.    
            if pctype = "D" then 
                ttUser.DomainName = pcValue.
            ttUser.id = ttUser.name 
                      + (if ttUser.DomainName > "" 
                         then "@" + ttUser.DomainName 
                         else "").
            OnRowCreated().
        end.
        temp-table ttUser:tracking-changes = false.
         
    end method.  
	
	method private character GetCreateError(userImpl as IUser):
        return this-object:GetCreateError(cast(userImpl,IDataAdminElement),userImpl:Name). 
    end method.
         
	/* called with tracking-changes */
    method protected override void CopyNewTableForParent(pRow as IRow,phTbl as handle):       
        case pRow:SerializeName:
            when "tenants" then
            do:
                CopyNewForTenant(pRow:KeyValue,table-handle phtbl by-reference).
            end.   
            otherwise 
                undo, throw new IllegalArgumentError("UserContext:ImportNewTableForParent parent " + quoter(pRow:SerializeName)).
     
        end.     
    end method.
     
	method private void CopyNewForTenant(pcVal as char,input table copytable ):
        define variable dataerror as DataContextError no-undo.      
        for each copytable on error undo, throw:  
            
            find ttUser where ttUser.TenantName = pcVal
                        and   ttUser.Name = copytable.Name 
                        and   ttUser.DomainName = copytable.DomainName no-error.
            if avail ttUser then  
                undo, throw new IllegalArgumentError("Tenant " +  quoter(pcVal)
                                                     + " already has a User with Name " + quoter(copytable.Name ) 
                                                     +  " and Domain " +   quoter(copytable.DomainName)).
            create ttuser.
            buffer-copy copytable to ttUser .           
        end.
    end method. 
	
	/** also used for name only - domain is then added later */ 
	method protected override void InitRow(pId as char):
	    define variable cDomain as character no-undo.
        define variable cUserid as character no-undo.
	    SplitId(pId,output cUserid,output cDomain).  
        create ttUser. 
        assign ttUser.Domainname = cDomain
               ttUser.name = cUserid .  
	end method.
    
	method public void CreateRow(userImpl as IUser):
         CreateRow(userimpl,?). 
    end method.
	
	method public void CreateRow(userImpl as IUser,pcDomain as char):
        define variable validateError as DataContextError no-undo.
        define variable newdomain as IDomain no-undo.
	    define variable cDomain as character no-undo.
	    temp-table ttUser:tracking-changes = true.
	    newdomain = userImpl:Domain.
         
	    if pcdomain <> ? then 
	    do: 
	        if valid-object(newdomain) then 
                undo, throw new IllegalArgumentError("Cannot add user " + quoter(userImpl:name) 
	                                                + " to Domain " + quoter(pcdomain) + "."
	                                                + " It already belongs to Domain " 
	                                                + quoter(newdomain:name)
	                                                ). 
	        cDomain = pcdomain.
	    end.
	    else if valid-object(newdomain) then
	    do:
	        cDomain = newDomain:name.
	    end.
	        
	    do on error undo, throw: 
	        Count = Count + 1.
	        create ttUser.
            assign 
                ttUser.Name            = userImpl:name
                ttUser.Entity          = userImpl
                ttUser.Id              = userImpl:Id
                ttUser.Name            = userImpl:Name
                ttUser.DomainName      = cDomain
         /*     ttUser.Tenant          = userImpl:Tenant:Name when valid-object(userImpl:Tenant).*/
                ttUser.Description     = userImpl:Description     
                ttUser.Number         = userImpl:Number
                ttUser.GivenName       = userImpl:GivenName
                ttUser.MiddleInitial   = userImpl:MiddleInitial
                ttUser.SurName         = userImpl:SurName
                ttUser.Password        = userImpl:Password
                ttUser.Telephone       = userImpl:Telephone 
                ttUser.Email           = userImpl:Email   
                .   
            OnRowCreated().      
            catch e as Error:  
                delete ttUser.
                Count = Count - 1.
                undo, throw new DataContextError(GetCreateError(userImpl),"User",e).  
            end catch.  
        end.
        finally:
            temp-table ttUser:tracking-changes = false.        		
        end finally.
    end method.
    
    method public override logical CanFind(pid as character):
        define variable cDomain as character no-undo.
        define variable cUserid as character no-undo.
        SplitId(pid,output cUserid,output cDomain).  
        return can-find(ttUser where ttUser.Domainname = cDomain
                               and   ttUser.name = cUserid).            
    end method.
     
    method public override logical Find(pid as character):
        define variable cDomain as character no-undo.
        define variable cUserid as character no-undo.
        
        SplitId(pid,output cUserid,output cDomain).  
        find ttUser where ttUser.Domainname = cDomain
                    and   ttUser.name = cUserid no-error.  
               
        return avail ttuser.            
    end method.
    
    method public logical CanFind(pid as char,pDomain as char):
        return can-find(ttUser where ttUser.Domainname = pDomain
                               and   ttUser.name = pid).                   
    end.     
     
    method public logical Find(pid as char,pDomain as char):
        find ttUser where ttUser.Domainname = pDomain
                    and   ttUser.name = pid no-error.  
        return avail ttUser.            
    end.     
     
    method private void SplitId(id as char,output puser as char, output pdomain as char): 
        if num-entries(id,"@") > 1 then 
            pdomain = entry(2,id,"@").
       
        puser = entry(1,id,"@").
             
    end method.
   
    /** create default filteredcontext that also handles parent/keyvalue as filter. */
    method override protected FilteredContext CreateFilteredContext(filter as char):
        return new UserQuery(this-object,filter).
    end method.
  
    /** create default filteredcontext with requestinfo  */
    method override protected FilteredContext CreateFilteredContext(pReq as IRequestInfo):
        return new UserQuery(this-object,pReq).
    end method.
  
    method override protected FilteredContext CreateFilteredContext(pparent as IRow, pReq as IRequestInfo):     
         case pparent:SerializeName:          
             when "domains" then
             do:              
                  return new DomainUserQuery(this-object,pparent:KeyValue,pReq).
             end.
             otherwise
                 return super:CreateFilteredContext(pparent,pReq).              
         end.        
    end method.
   
    method protected override IDataAdminCollection CreateCollection(cntxt as IDataAdminContext):
        return new UserSet(cntxt).
    end method.
    
    method protected override void ValidateBuffer(phUser as handle):
        define variable hBefore as handle no-undo.
         
        if phUser:row-state = row-modified or phUser:row-state = row-created and valid-object(Service) then
        do:
            hBefore = phUser:before-buffer.
            hBefore:find-by-rowid(phuser:before-rowid).
            if phUser::Password <> hBefore::Password then
            do:
                if valid-object(Service:PasswordPolicy) then
                    phUser::PreEncodePassword = Service:PasswordPolicy:PreEncodeUserPassword.
            end. 
        end.    
         
    end method. 
        
    method protected override IDataAdminElement CreateEntity(preq as IRequestInfo):
        return new User(this-object,pReq).
    end method.
    
    method protected override void ReadRowForParent(pRow as IRow,pjson as JSONObject).
        case pRow:SerializeName:
            when "tenants" then 
            do:
                ReadRowForTenant(pRow:KeyValues[1],pjson).    
            end.
            otherwise 
                 undo, throw new IllegalArgumentError("ReadRowForParent " +  quoter(pRow:SerializeName)).
        end case.         
    end method.    
    
    method private void ReadRowForTenant(pcVal as char,pjson as JSONObject):    
        define variable cId as character no-undo init ?.
        define variable cName as character no-undo init ?.
        define variable cDomainName as character no-undo init ?.
        define variable lUseid as logical no-undo.
        if pjson:Has("id") then
           cId = pjson:GetCharacter("id").
        if pjson:Has("name") then
            cName = pjson:GetCharacter("name").
        if pjson:Has("domainName") then
            cDomainName = pjson:GetCharacter("domainName").
        
        if cName = ? and cDomainName = ?  then
        do: 
            luseid = true.
            find ttUser where ttUser.TenantName = pcVal
                        and   ttUser.Id         = cId.
             
        end.
        else do:
            find ttUser where ttUser.TenantName = pcVal
                        and   ttUser.Name = cName 
                        and   ttUser.DomainName = cDomainName.       
        end.
        if avail ttUser then 
        do:
            ReadRow(pjson,"Id,Name,DomainName").
        end.
        catch e as Progress.Lang.Error :
        	if e:GetMessageNum(1) = 138 then
        	do:
        	    if luseid then
                    undo, throw new IllegalArgumentError("User " +  quoter(cid) + " was not found").
                else 
        	        undo, throw new IllegalArgumentError("User " +  quoter(cname) + " " + quoter(cDomainName) + " was not found").
            end.    
            else 
                undo, throw e.     
        end catch.   
            
    end method.
    
    method protected override char FindExpression(pusrid as char):
        define variable cDomain as character no-undo.
        define variable cUserid as character no-undo.
        
        SplitId(pusrid,output cUserid,output cDomain).  
        
        return  "ttUser.DomainName = " + quoter(cDomain) 
              + " and "
              + "ttUser.Name = " + quoter(cUserid) .
    end method.
    
    /* Override to split id in name and domain  
       We do remove @ from id for user with no domain in copyTables but not in 
       ReadJson* so the record may have "<name>@' in buffer or Row.keyvalues 
       before being copied into context, so it is safer to use name annd domain in expression than removing @ from id in this case
       (we do this in Find also ) 
       (this was added to ensure this works when RowBuffer:NewContext calls GetWhere
        - GetWhere was fixed to call this) 
       */ 
    method public override character ColumnExpression (pcColumn as char, pcOperator as char, pcValue as char):
        define variable cExpress as character no-undo.
        define variable cName as character no-undo.
        define variable cDomain as character no-undo.
        
        if pcColumn = "ttUser.Id" then 
        do: 
            SplitId(pcValue,output cName,output cDomain).
            /* ensure domain is in query also when blank in expression value */
            if lookup(pcoperator,"EQ,=") > 0 then
            do:
                cExpress = "(ttUser.name " + pcOperator + " " + quoter(cName)
                         + " and ttUser.DomainName " + pcOperator + " " + quoter(cDomain)
                         + ")".  
            end.                
            else if cDomain = "" then
                cExpress = "(ttUser.name " 
                         + pcOperator
                         + " "
                         + quoter(cName) + ")".
            else          
                cExpress = "(ttUser.name + " 
                         +  "(if ttUser.DomainName = '' then '' else '@' + ttUser.DomainName) "
                         + pcOperator
                         + " "
                         + quoter(pcValue) + ")".
          
            return cExpress.
        end.
        
        return super:ColumnExpression(pccolumn,pcOperator,pcValue).     
   
    end method.  
    method public override void DataRefreshed(pResponse as IFetchResponse):
        define variable i as integer no-undo.
        define variable tblResponse as ITableResponse no-undo.
        define variable hBuffer  as handle no-undo.
        /*            hds:copy-dataset(hCopy,yes,yes).*/
        if mRefresh or pResponse:Entityname <> "user" 
        then
        do: 
            super:DataRefreshed(pResponse).
        end.
        else do:   
            /* user context refresh any joined parents retrieved */       
            tblResponse = pResponse:GetTableResponse("ttTenant").
            if valid-object(tblResponse) then   
            do:
                mRefresh = true.          
                ContextFactory:TenantContext:DataRefreshed(pResponse) .
                mRefresh = false.
            end.
            else do:
                tblResponse = pResponse:GetTableResponse("ttDomain").
                if valid-object(tblResponse) then  
                do: 
                    mRefresh = true. 
                    ContextFactory:DomainContext:DataRefreshed(pResponse) .
                    mRefresh = false.
                end.
                else 
                    super:DataRefreshed(pResponse).
            end.
        end.       
    end method.   
    
end class.
