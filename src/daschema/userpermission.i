/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : userpermission.i
    Purpose     : 

    Syntax      :

    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/
 
define  temp-table ttUserPermission no-undo  serialize-name "userPermissions" {1}  
    field Name          as character      serialize-hidden /*"name"*/
    field Id            as character      serialize-name "id" format "x(30)"
    field DomainName    as character      serialize-hidden /*"domainName" */ format "x(25)"
    field UserUrl       as character      serialize-name  "user_url" 
    field DomainUrl     as character      serialize-hidden /* "domain_url" */  
    field Url           as character      serialize-hidden /*"url"*/
    {daschema/entity.i} 
    index idxDomain   as primary unique  DomainName Name    
    index idxuser  Name. 
    
