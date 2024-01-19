 /*************************************************************/
 /* Copyright (c) 2010-2016,2018 by progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Factory for DataAccess objects
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Aug 06 09:11:08 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.DataAccess.AllFieldData from propath.
using OpenEdge.DataAdmin.DataAccess.AllFileData from propath.
using OpenEdge.DataAdmin.DataAccess.AreaData from propath.
using OpenEdge.DataAdmin.DataAccess.AuthTagData from propath.
using OpenEdge.DataAdmin.DataAccess.AuthenticationSystemData from propath.
using OpenEdge.DataAdmin.DataAccess.CdcTablePolicyData from propath.
using OpenEdge.DataAdmin.DataAccess.DatabaseOptionData from propath.
using OpenEdge.DataAdmin.DataAccess.FileData from propath.
using OpenEdge.DataAdmin.DataAccess.FileDataChanges from propath.
using OpenEdge.DataAdmin.DataAccess.GrantedRoleData from propath.
using OpenEdge.DataAdmin.DataAccess.IDataAccess from propath.
using OpenEdge.DataAdmin.DataAccess.MetaData from propath.
using OpenEdge.DataAdmin.DataAccess.PartitionPolicyData from propath.
using OpenEdge.DataAdmin.DataAccess.RoleData from propath.
using OpenEdge.DataAdmin.DataAccess.SequenceValueData from propath.
using OpenEdge.DataAdmin.DataAccess.TenantGroupData from propath.
using OpenEdge.DataAdmin.DataAccess.TenantGroupMemberData from propath.
using OpenEdge.DataAdmin.DataAccess.UserData from propath.
using OpenEdge.DataAdmin.DataSource.AreaDataSource from propath.
using OpenEdge.DataAdmin.DataSource.IDataSource from propath.
using OpenEdge.DataAdmin.DataSource.TableDataSource from propath.
using OpenEdge.DataAdmin.DataSource.TablePermissionDataSource from propath.
using OpenEdge.DataAdmin.DataSource.TenantDataSource from propath.
using OpenEdge.DataAdmin.DataSource.TenantGroupDataSource from propath.
using OpenEdge.DataAdmin.DataSource.UserDataSource from propath.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.
using Progress.Lang.Error from propath.
using Progress.Lang.Object from propath.

class OpenEdge.DataAdmin.DataAccess.DataAccessFactory: 
    define variable ServiceName as character no-undo.
    
    define  temp-table ttDA no-undo 
        field Name as char
/*        field databaseName as char*/
        field Dao as Object
        index idxname as unique name.
                  

	define public property KeepAlive as logical no-undo 
/*	init true*/
	get.
	set. 

    /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/	
	constructor DataAccessFactory ( name as char):
		super ().	
        this-object:ServiceName =  name. 
	end constructor.
    
    /* to be used for single table and row requests using keyvalues
       instead of querty 
       This is optional and returns ? if no source is found 
       (note that ideally all classes should return something 
         the dynamic code tries to cover as much as possible 
        The dynamic resolution for classes with multiple camle cases in name 
        like TenantGroup may work in windows and not on unix, so should be hard coded   ) */ 
    method public IDataSource GetDataSource(pName as char):
        create alias dictdb for database value(ServiceName).
      
        define variable oSrc as IDataSource no-undo. 
        
        case pName:
            when "Area" then
                return new AreaDataSource().
            when "PartitionPolicy" then do:
                /* does not compile in non-partitioned database 
                  (we cannot really rely on correct casing in parameter (on unix) 
                   so do this dynamic, but hardcoded)*/
                oSrc = dynamic-new "OpenEdge.DataAdmin.DataSource.PartitionPolicyDataSource" ().
                return oSrc.
            end.
            when "Table" then 
                return new TableDataSource().
            when "Tenant" then
                return new TenantDataSource().
            when "TenantGroup" then
                return new TenantGroupDataSource().
            when "User" then
                return new UserDataSource().
            /* user permission relies on DataAccess to create dummy user when user not in _user */  
            when "UserPermission" then
                return ?.    
            when "TablePermission" then
                return new TablePermissionDataSource().        
            when "CdcTablePolicy" then do:
                 /* does only compile in a cdc enabled database 
                  (we cannot really rely on correct casing in parameter (on unix) 
                   so do this dynamic, but hardcoded)*/
                oSrc = dynamic-new "OpenEdge.DataAdmin.DataSource.CdcTablePolicyDataSource" ().
                return oSrc.
            end.    
            otherwise do on error undo, throw:
                oSrc = dynamic-new "OpenEdge.DataAdmin.DataSource." + pName + "DataSource" ().
                return oSrc.
                catch e as Error :
                    /* no complain - this is optional */ 
                    return ?.   
                end catch. 
            end.           
        end case.            
    end method.
        
    method public IDataAccess GetDataAccess(name as char):
        define variable da as IDataAccess no-undo.
        if KeepAlive then      
            find ttDa where  ttDa.name         = name no-error.
        
        if KeepAlive = false or not avail ttDa then 
        do: 
            create alias dictdb for database value(ServiceName).
            if name = "Permission" then
                da = new MetaData().            
            else if name = "TenantGroupMember" then
                da = new TenantGroupMemberData().              
            else if name = "TenantGroup" then
                da = new TenantGroupData(). 
            else if name = "PartitionPolicy" 
                    or name = "PartitionPolicyDetail"   
                    or name = "PartitionPolicyField"   
                    or name = "LocalIndex"  then
                da = new PartitionPolicyData().
            else if name = "CdcTablePolicy" 
                    or name = "CdcFieldPolicy" 
                     then
                da = new CdcTablePolicyData().    
            else if name = "AllTable" then
                da = new AllFileData().
            else if name = "AllField" then
                da = new AllFieldData().              
            else if name = "Schema" 
                 or name = "Table" 
                 or name = "Index" 
                 or name = "Field" 
                 or name = "IndexField" 
                 or name = "DataSecurity"
                 or name = "Administrator"
                 or name = "SecurityOptions"    
                 or name = "TablePermission" 
                 or name = "FieldPermission" then 
                da = new FileData().    
            else if name = "UserPermission" 
                 or name = "UserTablePermission" then 
                da = new UserData().    
            else if name = "SchemaChanges" then 
                da = new FileDataChanges().
            else if name = "AuthenticationSystem" then 
                da = new AuthenticationSystemData().
            else if name = "Sequence" then 
                da = new FileData().            
            else if name = "SequenceValue" then 
                da = new SequenceValueData().            
            else if name eq 'DatabaseOption':u then
                da = new DatabaseOptionData().
            else if name eq 'AuthTag':u then
                da = new AuthTagData().
            else if name eq 'Role':u then
                da = new RoleData().
            else if name eq 'GrantedRole':u then
                da = new GrantedRoleData().
            else if name eq 'Extent':u then
                da = new AreaData().            
            else
            do on error undo, throw:
                name = caps(substr(name,1,1)) + lc(substr(name,2)).
                da = dynamic-new "OpenEdge.DataAdmin.DataAccess." + name + "Data" (). 
             
                catch e as Progress.Lang.Error :
                     undo, throw new UnsupportedOperationError("DataAccessFactory cannot provide DataAccess for " + quoter(name) + "."
                                      + "~n" + e:GetMessage(1)).
                end catch.
            end.
            if KeepAlive then
            do:
                create ttDa.
                assign ttDa.name         = name 
                       ttDA.Dao          = da.
            end.
        end. 
        else 
            da = cast(ttDA.Dao,IDataAccess).
     
        return da.  
    end method.    
    
    
     
end class.
