/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : tenantgroupmember.i
    Author(s)   : hdaniels
    Created     : 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttTenantGroupMember no-undo serialize-name "tenantGroupMembers"  {1} 
        before-table ttTenantGroupMemberCopy
     field TenantGroupName  as character serialize-name "tenantGroupName"
     
     field TenantName          as character serialize-name "tenantName"
     /* TenantGroup Decription denormalized for JSON - not exposed in API */ 
     field TenantGroupDescription   as character serialize-name "tenantGroupDescription"
     field TenantGroupUrl   as character serialize-name "tenantGroup_url"
     
     /* denormalized for JSON - not in API */
     field SchemaName          as character serialize-name "schemaName"
     field TableName           as character serialize-name "tableName"
     
     /* Tenant Decription denormalized for JSON - not exposed in API */ 
     field TenantDescription   as character serialize-name "tenantDescription"
     field TenantUrl           as character serialize-name "tenant_url"
     field Url                 as character serialize-name "url"    
   /* needed for replace fill   */
     field ObjectType      as int serialize-hidden init?
     field ObjectNumber    as int serialize-hidden  init ?          
     field TenantGroupId    as int serialize-hidden init ?  
     field TenantId    as int serialize-hidden init  ?    
/*     field TableName       as character serialize-name "tableName"*/
    {daschema/entity.i}  
    index idxintId as unique ObjectType ObjectNumber TenantGroupId TenantId
    index idxId as primary  unique TenantGroupName TenantName
    index idxTenant  TenantName.
/*    index idxName  TableName.*/
    
    
