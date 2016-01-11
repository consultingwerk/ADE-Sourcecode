/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : domain.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
  
define  temp-table ttDomain no-undo  serialize-name "domains" {1} before-table ttDomainCopy
         field Name as char                               serialize-name "name"        format "x(25)"
         field Id              as integer  init ?         serialize-hidden
         field AuthenticationSystemName  as character     serialize-name "type"        format "x(10)"
         field TenantName      as character               serialize-name "tenantName"  format "x(20)" label "Tenant"
         field IsBuiltin       as logical                 serialize-name "isBuiltin" label "Built-in"
         field IsEnabled       as logical  init true      serialize-name "isEnabled" label "Enabled" 
         field Description     as character               serialize-name "description" format "x(25)"
         field Comments        as character               serialize-name "comments"    format "x(40)"
         field TenantURL       as character               serialize-name "tenant_url"  format "x(20)" label "Tenant url"
         field AuditingContext as character               serialize-name "auditingContext" format "x(16)" label "Auditing context"
         field AccessCode      as character               serialize-name "accessCode" label "Access code"
         field SystemOptions   as character               serialize-name "systemOptions"  format "x(13)" label "Runtime options"
         field RuntimeOptions  as character               serialize-name "runtimeOptions"  format "x(13)" label "Runtime options"
         field UsersUrl        as character               serialize-name "users_url" format "x(20)" label "Users url"
         field URL             as character               serialize-name "url" format "x(30)" label "Url"
         field TenantId        as integer                 serialize-hidden
         
         {daschema/entity.i}
         index idxName as primary unique Name  
         index idxTenant TenantName
         index idxId Id .
