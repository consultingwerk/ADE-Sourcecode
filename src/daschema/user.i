/*************************************************************/
/* Copyright (c) 2010-2012 by Progress Software Corporation. */  
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
    Created     : Sat Apr 03 23:35:34 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
 
define  temp-table ttUser no-undo  serialize-name "users" {1} before-table ttUserCopy
    field Name          as character      serialize-name "name"
    field Password      as character      serialize-name "password"
    field Id            as character      serialize-name "id" format "x(30)"
    field Description   as character      serialize-name "description"
    field IsSqlOnly     as logical        serialize-name "isSqlOnly"  
    field DomainName    as character      serialize-name "domainName" format "x(25)"
    field DomainId      as integer        serialize-hidden 
    field DomainUrl     as character      serialize-name "domain_url"  
    field TenantName    as character      serialize-name "tenantName" format "x(20)"
    /* currently used for query mapping */
    field TenantId      as integer        serialize-hidden init ?
    field TenantUrl     as character      serialize-name "tenant_url"
    field UserPermissionUrl as character  serialize-name "userPermission_url"
    field GivenName     as character      serialize-name "givenName"
    field MiddleInitial as character      serialize-name "middleInitial"
    field SurName       as character      serialize-name "surName"
    field Telephone     as character      serialize-name "telephone"
    field EMail         as character      serialize-name "email"
    field Url           as character      serialize-name "url"
    {daschema/entity.i} 
    index idxDomain   as primary unique DomainName Name  
    index idxTenant TenantName   
    index idxTenantId TenantId    
    index idxuser  Name. 
    
