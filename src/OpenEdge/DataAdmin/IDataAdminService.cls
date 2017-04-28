/*************************************************************/
/* Copyright (c) 2014-2016 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/** 
   Purpose     : Data Admin Service with crud methods for collections (IDataAdminCollection) 
                 and entities (IDataAdminElement) and ExecuteUtility for IDataAdminUtility 
                 instances. 
                  
   Syntax      : 
   Description : 
   Author(s)   : hdaniels
   Created     : Sat Jul 10 23:27:42 EDT 2010
   Notes       :  
   */
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Core.FileLogger from propath.
using OpenEdge.DataAdmin.Core.IPasswordPolicy from propath.
using OpenEdge.DataAdmin.IAdministrator from propath.
using OpenEdge.DataAdmin.IArea from propath.
using OpenEdge.DataAdmin.IAreaSet from propath.
using OpenEdge.DataAdmin.IAuthenticationSystem from propath.
using OpenEdge.DataAdmin.IAuthenticationSystemSet from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IDatabaseOption.
using OpenEdge.DataAdmin.IDatabaseOptionSet.
using OpenEdge.DataAdmin.IDataSecurity from propath.
using OpenEdge.DataAdmin.IDomain from propath.
using OpenEdge.DataAdmin.IDomainSet from propath.
using OpenEdge.DataAdmin.IExtent from propath.
using OpenEdge.DataAdmin.IGrantedRole.
using OpenEdge.DataAdmin.IGrantedRoleSet.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IPartitionPolicy from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetail from propath.
using OpenEdge.DataAdmin.IPartitionPolicyDetailSet from propath.
using OpenEdge.DataAdmin.IPartitionPolicySet from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.IRole.
using OpenEdge.DataAdmin.IRoleSet.
using OpenEdge.DataAdmin.ISchema from propath.
using OpenEdge.DataAdmin.ISequence from propath.
using OpenEdge.DataAdmin.ISequenceSet from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.ITablePermission from propath.
using OpenEdge.DataAdmin.ITablePermissionSet from propath.
using OpenEdge.DataAdmin.ITableSet from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.ITenantGroupMember from propath.
using OpenEdge.DataAdmin.ITenantGroupSet from propath.
using OpenEdge.DataAdmin.ITenantSet from propath.
using OpenEdge.DataAdmin.IUser from propath.
using OpenEdge.DataAdmin.IUserPermission from propath.
using OpenEdge.DataAdmin.IUserPermissionSet from propath.
using OpenEdge.DataAdmin.IUserSet from propath.
using OpenEdge.DataAdmin.IUserTablePermissionSet from propath.
using OpenEdge.DataAdmin.Util.IDataAdminUtility from propath.
using OpenEdge.DataAdmin.Util.IUtilityFactory from propath.
using Progress.Lang.Error from propath.
 
interface OpenEdge.DataAdmin.IDataAdminService : 
    
    /** published when the service is deleted - considered internal */
	define public event ServiceDeleted     signature void ().
	
	/** Url for REST - will be returned as first part of url properties in JSON */
    define public property Url as char no-undo get. set.
    
    /** ThrowDataError - true  - throw data errors as other errors
                         false - don't throw data errors. All data errors to the Error property 
                         to be accessed with GetError, RemoveError Or ThrowError. 
                         This will cause the logical Update and Create methods to return false
                         when a data error occurs. */
    define public property ThrowDataErrors as logical no-undo get. set.
    
    /** TransactionLogger - set a FileLogger that will receive a log entry before and after 
                            each transaction (Create orUpdate ) or command (EcecuteUtiltiy) call */
    define public property TransactionLogger as FileLogger no-undo get. set.    
    
    /** PasswordService - PasswordPolicy with password rule properties 
        (pre-encode password or passcode)   */
    define public property PasswordPolicy as IPasswordPolicy no-undo get. set.    
    
    /** Service name - currently database name - read-only */
    define public property Name as character no-undo get.
    
     /**utility factory - read-only */
    define public property UtilityFactory as IUtilityFactory no-undo get.
   
    /* not yet
    /** LocalContextScope decides context scope for New<Entity> methods 
             Service = One local scope for the service 
                       - can only have one new instance active with same key at any time
                       - child collection shares scope of new entities of same type 
             Instance  = One local scope for each new instance 
                       - can have more than one new instances active with same key     */
    define public property LocalContextScope  as char no-undo get. set.
    */
      
    /** Cancel current schema changes 
        The service only supports one active context retrieved with GetShemaChanges(). 
        Use this before calling GetShemaChanges again if the returned schema was not passed to 
        UpdateSchemaChanges() */
    method public logical CancelSchemaChanges(). 
    
    /** Delete a schema instance with schema changes- not required since 
        CancelSchemaChanges does the same thing  */
    /*method public logical DeleteSchemaChanges(pschema as ISchema).*/
    
    /** create a collection */
    method public logical CreateCollection(pccol as IDataAdminCollection).
  
    /** Create a new area  
        @param IArea to be created */
    method public logical CreateArea(area as IArea).
        
    /** Create new areas  
        @param IAreaSet with a collection of areas to create */
    method public logical CreateAreas(areas as IAreaSet).
    
    
    /** Create a new authentication system  
        @param system IAuthenticationSystem to be created */
    method public logical CreateAuthenticationSystem(authenticationsystem as IAuthenticationSystem).
    
    /** Create new authentication systems  
        @param systems IAuthenticationSystemSet with a collection of authentication systems to create */
    method public logical CreateAuthenticationSystems(authenticationsystems as IAuthenticationSystemSet).
   
    /** Create a new domain  
        @param domain IDomain to be created */
    method public logical CreateDomain(domain as IDomain).
   
    /** Create new domains  
        @param domains IDomainSet with a collection of domains to create */
    method public logical CreateDomains(domains as IDomainSet).
    
   /** Create a new partition policy 
        @param policy IPartitionPolicy to be created */
    method public logical CreatePartitionPolicy(policy as IPartitionPolicy).
   
   /** Create a new partition policy  
        @param policies IPartitionPolicySet with policies to be created */
    method public logical CreatePartitionPolicies(policies as IPartitionPolicySet).
    
    /** Create a new group  
        @param group ITenantGroup to be created */
    method public logical CreateTenantGroup(newgroup as ITenantGroup).
    
    /** Create new groups  
        @param groups ITenantGroupSet with a collection of groups to create */
    method public logical CreateTenantGroups(groups as ITenantGroupSet).
    
    /** Create a new sequence  
        @param sequence ISequence to be created */
    method public logical CreateSequence(sequence as ISequence).
   
    /** Create new sequences  
        @param sequences ISequenceSet with a collection of sequences to create */
    method public logical CreateSequences(sequences as ISequenceSet).
        
    /** Create a new tenant  
        @param ITenant to be created */
    method public logical CreateTenant(tenant as ITenant).
    
    /** Create new tenants  
        @param tenants ITenantSet with a collection of tenants to create */
    method public logical CreateTenants(tenants as ITenantSet).
    
    /** Create a new user  
        @param user IUser to be created */
    method public logical CreateUser(usr as IUser).
    
    /** Create new users  
        @param users IUserSet with a collection of users to create */
    method public logical CreateUsers(users as IUserSet).
        
    /** Create a new role  
        @param IRole The role to be created */
    method public logical CreateRole(role as IRole).
   
    /** Create new roles  
        @param IRoleSet A collection of roles to create */
    method public logical CreateRoles(roles as IRoleSet).

    /** Create a new role grant

        @param IGrantRole The role to be created
        @return logical TRUE if the grant was created */
    method public logical CreateGrantedRole(input poGrant as IGrantedRole).
   
    /** Create new role grants  
        
        @param IGrantedRoleSet A collection of roles to create
        @return logical TRUE if the grant was created */
    method public logical CreateGrantedRoles(input poGrants as IGrantedRoleSet).

    /** Create a new database option  
    
        @param IDatabaseOption The role to be created 
        @return logical TRUE if the dboption was created */
    method public logical CreateDatabaseOption(input poDbOption as IDatabaseOption).
   
    /** Create new database options
          
        @param IDatabaseOptionSet A collection of roles to create 
        @return logical TRUE if the dboptions were created */
    method public logical CreateDatabaseOptions(input poDbOption as IDatabaseOptionSet).

    /** Delete granted role   
        @param character The ID of the granted role to delete
        @throws NotFoundError if role does not exist */
    method public logical DeleteGrantedRole(input pcGrantId as character).
    
    /** Delete domain  
        @param domainName name of domain to delete 
        @throws NotFoundError if domain does not exist */
    method public logical DeleteDomain(domainName as char).
    
    /** Delete authentication system
        @param authenticationsystemName name of authentication system to delete. 
        @throws NotFoundError if authentication system does not exist. */
    method public logical DeleteAuthenticationSystem(authenticationsystemName as char).

    /** Delete PartitionPolicy 
        @param policyName name of policy to delete. 
        @throws NotFoundError if policy does not exist. */
    method public logical DeletePartitionPolicy(tenantName as char).
    
    /** Delete tenant 
        @param tenantName name of tenant to delete. 
        @throws NotFoundError if tenant does not exist. */
    method public logical DeleteTenant(tenantName as char).
        
    /** Delete group 
        @param groupName name of group to delete. 
        @throws NotFoundError if group does not exist. */
    method public logical DeleteTenantGroup(groupName as char).
    
    /** Delete sequence  
        @param sequenceName name of sequence to delete. 
        @throws NotFoundError if sequence does not exist. */
    method public logical DeleteSequence(seqname as char).
    
    /** Delete domain  
        @param domainName name of domain to delete 
        @throws NotFoundError if user does not exist */
    method public logical DeleteUser(usrId as char).
    
    /** Get a collection of the specified serializename, entity name or physical database filename  */
    method public IDataAdminCollection GetCollection(pcname as char).
    
     /** Get a collection specified by the request in the database */
    method public IDataAdminCollection GetCollection(pRequestInfo as IRequestInfo):
    
    /* get administrator - has administrator user ids */
    method public IAdministrator GetAdministrator().
    
    /** Get an area  
        @param areaname name of area */
    method public IArea GetArea(areaName as char).
    
    /** Get an area  
        @param IRequestinfo that defines an expression that uniqely identifies an area  */
    method public IArea GetArea(req as IRequestInfo).
    
    /** Get an area  
        @param areaName Number of area */
    method public IArea GetArea(areaNum as int).
    
    /** Get a collection of all areas in the database */
    method public IAreaSet GetAreas().
    
    /** Get a collection of areas in the database *
        @param filter a character query expression of area properties */
    method public IAreaSet GetAreas(filter as char).
    
    /** Get a collection of all areas in the database 
        @param IRequestinfo with a QueryString that defines an expression of area properties */
    method public IAreaSet GetAreas(req as IRequestInfo).
    
    /** Get data security 
        @param domainName name of data security */
    method public IDataSecurity GetDataSecurity(pcKey as char).
    
    /** Get a role
          
        @param IRequestinfo that defines an expression that uniqely identifies a domain  
               with optional request info children with QueryStrings for child collections */
    method public IRole GetRole(input poreq as IRequestInfo).

    /** Get a role
          
        @param character The name of the role to retrieve*/
    method public IRole GetRole(input pcRoleName as character).
    
    /** Get a granted role
          
        @param character The id of the grant role to retrieve*/
    method public IGrantedRole GetGrantedRole(input pcGrantId as character).

    /* Get a collection of all role grants in the database 
       
       @return IGrantedRoleSet A set of grants */
    method public IGrantedRoleSet GetGrantedRoles().
    
    /* Get a collection of role grants in the database
      
       @param character A character query filter expression of grant properties
       @return IGrantedRoleSet A set of grants */
    method public IGrantedRoleSet GetGrantedRoles(input pcFilter as character).
    
    /* Get a collection of granted roles 
         
       @param IRequestinfo with a QueryString that defines an expression of domain properties 
               with optional request info children with QueryStrings for child collections 
       @return IGrantedRoleSet A set of grants */
    method public IGrantedRoleSet GetGrantedRoles(input poRequestInfo as IRequestInfo).
    
    /** Get a collection of all security roles domains in the database */
    method public IRoleSet GetRoles().
    
    /** Get a collection of roles in the database
        @param filter a character query expression of domain properties */
    method public IRoleSet GetRoles(input pcFilter as character).
    
    /** Get a collection of all domains in the database 
        @param IRequestinfo with a QueryString that defines an expression of domain properties 
               with optional request info children with QueryStrings for child collections */
    method public IRoleSet GetRoles(input poRequestInfo as IRequestInfo).
        
    /** Get a new, empty db option
    
        Expected to be passed to CreateDatabaseOption() to be created in the database or added to a new or 
        existing IDatabaseOptionSet collection, to be submitted to the database with the collection. 
        
        @param character The name of the new option
        @return IDatabaseOption The new dboption */
    method public IDatabaseOption NewDatabaseOption(input pcOptionCode as character).
    
    /** Get an empty dboption collection
      
        Add new roles to the collection and pass it to CreateDatabaseOptions() to create the 
        options in the database. 
        
        @return IDatabaseOptionSet A new empty collection of dboptions */ 
    method public IDatabaseOptionSet NewDatabaseOptions().
        
    /* Get a collection of db options
       
       @return IDatabaseOptionSet A colletion of the dboptions */
    method public IDatabaseOptionSet GetDatabaseOptions().

    /* Get a db option record by code
       
       @param character The db option code
       @return IDatabaseOption The database option */
    method public IDatabaseOption GetDatabaseOption(input pcOptionCode as character).
    
    /** Get a collection of database options
        
        @param filter a character query expression of db options */
    method public IDatabaseOptionSet GetDatabaseOptions(input pcFilter as character).
    
    /** Get a collection of database options 
        @param IRequestinfo with a QueryString that defines an expression of dboptionproperties 
               with optional request info children with QueryStrings for child collections */
    method public IDatabaseOptionSet GetDatabaseOptions(input poRequestInfo as IRequestInfo).
            
    /** Get a domain 
        @param domainName name of domain */
    method public IDomain GetDomain(domainName as char).
    
    /** Get a domain  
        @param IRequestinfo that defines an expression that uniqely identifies a domain  
               with optional request info children with QueryStrings for child collections */
    method public IDomain GetDomain(req as IRequestInfo).
   
    /** Get a collection of all domains in the database */
    method public IDomainSet GetDomains().
   
    /** Get a collection of domains in the database *
        @param filter a character query expression of domain properties */
    method public IDomainSet GetDomains(filter as char).
    
    /** Get a collection of all domains in the database 
        @param IRequestinfo with a QueryString that defines an expression of domain properties 
               with optional request info children with QueryStrings for child collections */
    method public IDomainSet GetDomains(pRequestInfo as IRequestInfo).
    
    /** Get a authentication system  
        @param systemName name of authentication system  */
    method public IAuthenticationSystem GetAuthenticationSystem(name as char).
    
    /** Get a collection of all authentication systems in the database */
    method public IAuthenticationSystemSet GetAuthenticationSystems(). 
   
    /** Get a collection of authentication systems in the database *
        @param filter a character query expression of authentication system properties */
    method public IAuthenticationSystemSet GetAuthenticationSystems(filter as char).
    
    /** Get a collection of authentication systems in the database *
        @param IRequestinfo with a QueryString that defines an expression of authentication system properties */
    method public IAuthenticationSystemSet GetAuthenticationSystems(req as IRequestInfo).
    
    /** Get a tenant group
        @param groupName name of tenant group */
    method public ITenantGroup GetTenantGroup(groupName as char).  
   
    /** Get a tenant group
        @param groupId Id of tenant group */
    method public ITenantGroup GetTenantGroup(groupId as int).
    
    /** Get a tenant group
        @param IRequestinfo that defines an expression that uniqely identifies a tenant group 
               with optional request info children with QueryStrings for child collections */
    method public ITenantGroup GetTenantGroup(pRequestInfo as IRequestInfo).
  
    /** Get a collection of all tenant groups in the database */
    method public ITenantGroupSet GetTenantGroups().
   
    /** Get a collection of tenant groups in the database *
        @param filter a character query expression of group properties */
    method public ITenantGroupSet GetTenantGroups(filter as char).
  
    /** Get a collection of tenant groups in the database *
        @param filter a character query expression of group properties 
               with optional request info children with QueryStrings for child collections */
    method public ITenantGroupSet GetTenantGroups(pRequestInfo as IRequestInfo).
    
    /** Get a sequence 
        @param sequenceName name of sequence  */
    method public ISequence GetSequence(SeqName as char).
    
    /** Get a sequence 
        @param IRequestinfo that defines an expression that uniqely identifies a sequence  
               with optional request info children with QueryStrings for child collections */
    method public ISequence GetSequence(reqInfo as IRequestInfo).
    
    /** Get a collection of sequences in the database */
    method public ISequenceSet GetSequences().
   
    /** Get a collection of sequences in the database 
        @param filter a character query expression of sequence properties */
    method public ISequenceSet GetSequences(filter as char).
   
    /** Get a collection of sequences in the database 
        @param filter a character query expression of sequence properties 
               with optional request info children with QueryStrings for child collections */
    method public ISequenceSet GetSequences(reqInfo as IRequestInfo).
    
    /** Get the Schema - the service only supports "PUB" schema */
    method public ISchema GetSchema(). 
    
    /** the service only supports "pub" schema so no key parameter */
    method public ISchema GetSchema(pRequestInfo as IRequestInfo).
    
    /** Get a schema with changes from the specified schema file (.df) 
        The Partitions property will have all new partitions that were created after
        the schema is passed to LoadSchemaChanges */
    method public ISchema GetSchemaChanges(pcFile as char).
   
    /** Load schema changes in the datbase from the specified schema file (.df) */
    method public logical LoadSchemaChanges(pcFile as char).
    
    /*  method public ISchemaSet GetSchemas(filter as char).*/
    
    /** Get a table 
        @param tableName name of sequence  */
    method public ITable GetTable(tableName as char).
    
    /** Get a table 
        @param IRequestinfo that defines an expression that uniqely identifies a tenant group 
                with optional request info children with QueryStrings for child collections */
    method public ITable GetTable(pRequestInfo as IRequestInfo).
   
    /** Get a collection of all tables in the database */
    method public ITableSet GetTables().
   
    /** Get a collection of tables in the database *
        @param filter a character query expression of table properties */
    method public ITableSet GetTables(filter as char).
    
    /** Get a collection of tables in the database *
        @param filter a character query expression of table properties 
               with optional request info children with QueryStrings for child collections */
    method public ITableSet GetTables(pRequestInfo as IRequestInfo).

    /** Get a table permission 
        @param tableName name of table permission  */
    method public ITablePermission GetTablePermission(tablename as char ).
    
    /** Get a collection of all table permissions in the database */
    method public ITablePermissionSet GetTablePermissions( ).
   
    /** Get a collection of table permissions in the database *
        @param filter a character query expression of table permission properties */
    method public ITablePermissionSet GetTablePermissions(filter as char).

    /** Get a tenant by external id 
        @param external id that uniquely identifes a tenant  
               Use GetTenants() with filter or Requestinfo with query expression on the 
               external id if the value is not unique  */
    method public ITenant GetTenantByExternalId(extId as char).
    
    /** Get a tenant  
        @param tenantId integer of of tenant */  
    method public ITenant GetTenant(tenantId as int).
    
    /** Get a tenant
        @param tenantName name of tenant */  
    method public ITenant GetTenant(tenantName as char).
   
    /** Get a tenant
        @param IRequestinfo that defines an expression that uniqely identifies a tenant 
                with optional request info children with QueryStrings for child collections */
    method public ITenant GetTenant(req as IRequestInfo).
   
    /** Get a collection of all tenants in the database */
    method public ITenantSet GetTenants( ).
    
    /** Get a collection of tenants in the database 
        @param filter a character query expression of tenant properties */
    method public ITenantSet GetTenants(filter as char).
   
    /** Get a collection of tenants in the database 
        @param filter a character query expression of tenant properties 
               with optional request info children with QueryStrings for child collections */
    method public ITenantSet GetTenants(pRequestInfo as IRequestInfo).
    
    /** Get a PartitionPolicy  
        @param  name char of PartitionPolicy*/ 
    method public IPartitionPolicy GetPartitionPolicy(pname as char).
    
    /** Get a PartitionPolicy  
         @param  request IRequestInfo*/ 
    method public IPartitionPolicy GetPartitionPolicy(pRequestInfo as IRequestInfo).
    
    /** Get a collection of all partition policies  in the database   */ 
    method public IPartitionPolicySet GetPartitionPolicies().
   
    /** Get a collection of partition policies 
        @param  request IRequestInfo*/ 
    method public IPartitionPolicySet GetPartitionPolicies(pRequestInfo as IRequestInfo).
   
    /** Get a collection of partition policies 
        @param  filter  */ 
    method public IPartitionPolicySet GetPartitionPolicies(pFilter as char).
   
   /** Get a collection of all partition policies details in the database   */
    method public IPartitionPolicyDetailSet GetPartitionPolicyDetails().
   
    /** Get a collection of  partition policies details   
         @param  request IRequestInfo*/ 
    method public IPartitionPolicyDetailSet GetPartitionPolicyDetails(pRequestInfo as IRequestInfo).
    
    /** Get a collection of  partition policies details   
       @param  filter  */ 
    method public IPartitionPolicyDetailSet GetPartitionPolicyDetails(pFilter as char).
   
    /** Get a collection of permissions for the specified collections 
        @param collections a comma separated list of collections known by the service */ 
    method public IUserTablePermissionSet GetPermissions(pccollections as char).
    
   /** Get a user permission 
        @param userid user id of user in the form <name>@<domain> 
               the user id does not need to exist */  
    method public IUserPermission GetUserPermission(usrID as char).
    
    /** Get a collection of all user permissions  in the database */
    method public IUserPermissionSet GetUserPermissions().
   
    /** Get a collection of user permissions in the database 
        @param filter a character query expression of user permission properties */
    method public IUserPermissionSet GetUserPermissions(filter as char).
    
    /** Get a user
      @param userid user id of user in the form <name>@<domain> */  
    method public IUser GetUser(usrID as char).

    /** Get a collection of all users in the database */
    method public IUserSet GetUsers().
   
    /** Get a collection of users in the database *
        @param filter a character query expression of user properties */
    method public IUserSet GetUsers(pcfilter as char).
   
    /** Get a collection of users in the database *
        @param filter a character query expression of user properties. */
    method public IUserSet GetUsers(pReq as IRequestInfo).
     
    /** Get a new collection of the specified serializename, entity name or physical database filename  */
    method public IDataAdminCollection NewCollection(pcname as char).
  
    /** Get a new area   
        Expected to be passed to CreateArea() to be created in the database or added to a new or 
        existing IAreaSet collection to be submitted to the database with the collection.
        
        @param areaname name of the new area */
    method public IArea NewArea(pname as char).
    
    /** Get an empty area collection  
        Add new areas to the collection and pass it to CreateAreas() to create the areas in the database. */ 
    method public IAreaSet NewAreas().
    
    /** Get a new extent     
        Expected to be added to an IArea:Extents collection to be submitted to the database 
        using the service's CreateArea() or UpdateAreas() methods.*/ 
    method public IExtent NewExtent().
    
     /** Get a new index     
        Expected to be added to an ITable:Indexes collection to be submitted to the database 
        using the service's CreateTable() or UpdateTables() methods.*/ 
    method public IIndex NewIndex().
    
    /** Get a new tenant group member    
        Expected to be added to an ITenant or ITenantGroup TenantGroupMembers collection to be 
        submitted to the database using the service's CreateTenants() or UpdateTenants() methods.*/ 
    method public ITenantGroupMember NewTenantGroupMember().
        
    /** Get a new domain   
        Expected to be passed to CreateDomain() to be created in the database or added to a new or 
        existing IDomainSet collection, including the ITenant:Domains, to be submitted to the 
        database with the collection. 
     
        @param domainName name of the new domain */
    method public IDomain NewDomain(pname as char).
    
    /** Get an empty domain collection  
        Add new domains to the collection and pass it to CreateDomains() to create the domains in the database. */ 
    method public IDomainSet NewDomains().

    /** Get a new granted role
        
        @param character The Role name
        @return IGrantedRole The new grant role */
    method public IGrantedRole NewGrantedRole().
    
    /** Get a new granted role
        
        Expected to be added to an instance of IRole and submitted that way. 
     
        @return IGrantedRoleSet The new grant set */
    method public IGrantedRoleSet NewGrantedRoles().
        
    /** Get a new role
        Expected to be passed to CreateRole() to be created in the database or added to a new or 
        existing IRoleSet collection, to be submitted to the database with the collection. 
     
        @param character The name of the new role
        @return IRole The new role */
    method public IRole NewRole(input pcRoleName as character).
    
    /** Get an empty role collection  
        Add new roles to the collection and pass it to CreateRoles() to create the roles in the database. 
        
        @return IRoleSet A new empty colleciton of roles */ 
    method public IRoleSet NewRoles().

    /** Get a new authentication system  
        Expected to be passed to CreateAuthenticationSystem() to be created in the database 
        or added to a new or existing IAuthenticationSystemSet collection to be submitted to the 
        database with the collection.
         
        @param systemName name of the new authentication system */
    method public IAuthenticationSystem NewAuthenticationSystem(pname as char).
    
    /** Get an empty authentication system collection  
        Add new authentication systems to the collection and pass it to CreateAuthenticationSystems() 
        to create the authentication systems in the database. */ 
    method public IAuthenticationSystemSet NewAuthenticationSystems().
    
     /** Get an empty partition policy   */ 
    method public IPartitionPolicy NewPartitionPolicy(pname as char).
   
     /** Get an empty partition policy collection  */ 
    method public IPartitionPolicySet NewPartitionPolicies().
    
         /** Get an empty partition policy detail  */ 
     /*  Expected to be added to IPartitionPolicy:Details collection to be submitted to the database*/
     /*        using the service's UpdateTable() or UpdateTables() methods.*/
    method public IPartitionPolicyDetail NewPartitionPolicyDetail(pname as char).
    
    /** Get a new tenant
        Expected to be passed to CreateTenant() to be created in the database or added to a new 
        or existing ITenantSet collection to be submitted to the database with the collection. 
     
        @param tenantName name of the new tenant */
    method public ITenant NewTenant(pname as char).
    
    /** Get an empty tenant collection  
        Add new tenants to the collection and pass it to CreateTenants() to create the tenants 
        in the database. */ 
    method public ITenantSet NewTenants().
        
    /** Get a new tenant group
        Expected to be passed to CreateTenantGroup() to be created in the database or added to a new 
        or existing ITenantGroupSet collection to be submitted to the database with the collection. 
     
        @param groupName name of the new tenant group */
    method public ITenantGroup NewTenantGroup(pname as char).
    
    /** Get an empty tenant group collection  
        Add new tenant groups to the collection and pass it to CreateTenantGroups() to create the tenants 
        in the database. */ 
    method public ITenantGroupSet NewTenantGroups().
  
    /** Get a new sequence
        Expected to be passed to CreateSequence to be created in the database or added to a new 
        or existing ISequenceSet collection to be submitted to the database with the collection. 
     
       @param userid user id of user in the form <name>@<domain> */  
    method public ISequence NewSequence(pname as char).
    
    /** Get an empty sequence collection  
        Add new sequences to the collection and pass it to CreateSequences() to create the sequences 
        in the database. */ 
    method public ISequenceSet NewSequences().
        
    /** Get a new user
        Expected to be passed to CreateUser to be created in the database or added to a new 
        or existing IUserSet collection, including ITenant:Users or IDomin:Users to be submitted 
        to the database with the collection. 
     
       @param userid user id of user in the form <name>@<domain> */  
    method public IUser NewUser(pname as char).   
    
    /** Get an empty user collection  
        Add new users to the collection and pass it to CreateUsers() to create the users 
        in the database. */ 
    method public IUserSet NewUsers(). 
    
     /** Update a collection */
    method public logical UpdateCollection(pccol as IDataAdminCollection).
  
    /** Update the database with administrator changes 
        @param admin IAdministrator */ 
    method public logical UpdateAdministrator(admin as IAdministrator).
    
    /** Update the database with new extents added to the area
        @param area IArea */ 
    method public logical UpdateArea(area as IArea).
    
    /** Update the database with new extents added to the areas in the collection 
        @param areas IAreaset collection  */ 
    method public logical UpdateAreas(areas as IAreaSet).
    
    /** Update the database with security changes 
        @param securityInstance IDataSecurity   */ 
    method public logical UpdateDataSecurity(pinst as IDataSecurity ).
    
    /** Update the database with domain changes  
        @param domain IDomain */ 
    method public logical UpdateDomain(domain as IDomain).
    
    /** Update the database with changes for many domains 
        @param domains IDomainSet collection */ 
    method public logical UpdateDomains(domains as IDomainSet).
    
    /** Update the database with a changed dboption
        
        @param IDatabaseOption The updated db option  
        @return logical TRUE if the option was updated */
    method public logical UpdateDatabaseOption(input poDbOption as IDatabaseOption).
    
    /** Update the database with changes for many dboptions
        
        @param IDatabaseOptionSet A colleciton of db options 
        @return logical TRUE if the options were updated */
    method public logical UpdateDatabaseOptions(input poDbOptions as IDatabaseOptionSet).

    /** Update the database with a changed security role
        
        @param IRole The updated role  
        @return logical TRUE if the option was updated */
    method public logical UpdateRole(input poRole as IRole).
    
    /** Update the database with changes for many roles
        
        @param IRoleSet A collection of roles 
        @return logical TRUE if the options were updated */
    method public logical UpdateRoles(input poRoles as IRoleSet).

    /** Update the database with a changed role grant
        
        @param IGrantRole The updated grant  
        @return logical TRUE if the option was updated */
    method public logical UpdateGrantedRole(input poGrant as IGrantedRole).
    
    /** Update the database with changes for many granted roles
        
        @param IGrantedRoleSet A collection of granted roles 
        @return logical TRUE if the options were updated */
    method public logical UpdateGrantedRoles(input poGrants as IGrantedRoleSet).
        
    /** Update the database with authentication system changes  
        @param authenticationSystem IAuthenticationSystem */ 
    method public logical UpdateAuthenticationSystem(authenticationsystem as IAuthenticationSystem).
    
    /** Update the database with changes for many authentication systems 
        @param authenticationSystems IAuthenticationSystemSet collection */ 
    method public logical UpdateAuthenticationSystems(authenticationsystems as IAuthenticationSystemSet).
    
       /** Update the database with partition policy changes  
       @param policy IPartitionPolicy to be created */
    method public logical UpdatePartitionPolicy(policy as IPartitionPolicy).
   
   /** Update the database with partition policies with changes   
        @param policies IPartitionPolicySet with policies to be updated */
    method public logical UpdatePartitionPolicies(policy as IPartitionPolicySet).
    
    /** Update the database with sequence changes  
        @param sequence ISequence */ 
    method public logical UpdateSequence(seq as ISequence).
    
    /** Update the database with changes for many sequences
        @param sequences ISequenceSet collection */ 
    method public logical UpdateSequences(sequences as ISequenceSet).
    
    /** Update the database with table changes 
        @param table ITable */ 
    method public logical UpdateTable(tableimpl as ITable).
    
    /** Update the database with changes for many tables
        @param sequences ITableSet collection */ 
    method public logical UpdateTables(tables as ITableSet).    
  
    /** Update the database with table permission changes 
        @param tablePermission ITablePermission */ 
    method public logical UpdateTablePermission(tableperm as ITablePermission).
    
    /** Update the database with changes for many table permissions
        @param tablePermissions ITablePermissionSet collection */ 
    method public logical UpdateTablePermissions(tableperms as ITablePermissionSet)  .  
  
    /** Update the database with tenant group changes 
        @param group ITenantGroup */ 
    method public logical UpdateTenantGroup(tenantGroup as ITenantGroup).
   
    /** Update the database with changes for many tenant groups
        @param tenantGroups ITenantGroupSet collection */ 
    method public logical UpdateTenantGroups(tenantGroups as ITenantGroupSet).
  
    /** Update the database with tenant changes 
        @param tenant ITenant */ 
    method public logical UpdateTenant(ptnt as ITenant).
   
    /** Update the database with changes for many tenants
        @param tenants ITenantSet collection */ 
    method public logical UpdateTenants(tenants as ITenantSet).
  
    /** Update the database with schema changes returned from GetSchemaChanges  
        @param schema ISchema */ 
    method public logical UpdateSchemaChanges(pschema as ISchema).   
    
    /** Update the database with partition changes on new partitions created when the 
        schema definitions were added to the database with pdateSchemaChanges  
        @param schema ISchema */ 
    method public logical UpdateSchema(pschema as ISchema).

    /** Update the database with table permission changes 
        @param tablePermission ITablePermission */ 
    method public logical UpdateUser(usr as IUser).     
   
    /** Update the database with changes for many table permissions
        @param tablePermissions ITablePermissionSet collection */ 
    method public logical UpdateUsers(users as IUserSet).
     
    /** Execute the ulitility  */
    method public void ExecuteUtility(putility as IDataAdminUtility).
    
    /** Removes and returns the last error from a failed operation when ThrowDataErrors is false. */
    method public Error RemoveError().
    
    /** Get the last error from a failed operation when ThrowDataErrors is false. */
    method public Error GetError().
    
    /** Throw the last error from a failed operation when ThrowDataErrors is false. 
        The error is also removed from the service. */
    method public void ThrowError ().
            
end interface.
