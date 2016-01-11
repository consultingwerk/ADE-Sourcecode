/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : tenant.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Apr 03 23:21:09 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
define temp-table ttTenant no-undo serialize-name "tenants" {1} before-table ttTenantCopy  
     field Name  as character  serialize-name "name" 
     field Id    as integer   serialize-name "id" init ? 
     field ExternalId    as character   serialize-name "externalId" init "" 
     field Type  as character serialize-name "type" init "Regular"
     field Description as character   serialize-name "description"
     field IsDataEnabled as logical serialize-name "isDataEnabled" init true
     field IsAllocated as logical serialize-name "isAllocated"
     field URL   as character                  serialize-name "url"
     /* we can use different name since this will never be updated from client */
     field PartitionsURL as character              serialize-name "partitions_url" 
     field TenantGroupMembersURL as character   serialize-name "tenantGroupMembers_url" 
     /* link to list ALL areas for lookup purposes*/ 
     field AreasUrl as character  serialize-name "areas_url"
     field UsersUrl as character  serialize-name "users_url"
     field DomainsUrl as character  serialize-name "domains_url"
     field SequenceValuesUrl as character  serialize-name "sequenceValues_url"
     field DefaultDataAreaName as character  serialize-name "defaultDataAreaName" /* Must be valid TII area */
     field DefaultDataAreaUrl as character  serialize-name "defaultDataArea_url"  
     field DefaultIndexAreaName as character  serialize-name "defaultIndexAreaName" /* Must be valid TII area */
     field DefaultIndexAreaUrl as character  serialize-name "defaultIndexArea_url"  
     field DefaultLobAreaName as character  serialize-name "defaultLobAreaName" /* Must be valid TII area */
     field DefaultLobAreaUrl as character  serialize-name "defaultLobArea_url"  
     field DefaultAllocation as character  serialize-name "defaultAllocation"  
     {daschema/entity.i} 
     index TenantIdIdx as unique Id 
     index TenantNameIdx as primary  unique Name
. 