/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : usertablepermisssions.i
    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttUserTablePermission no-undo serialize-name "userTablePermissions"  {1} 
     /* not likely, but could happen if database is normalized --
         before-table ttUserTablePermissionCopy */
         
     /* init ? is needed to avoid already exists error during fill when 
        the OTHER fields Schemaname name in the unique index are mapped and 
        also exists in an index so the index update is triggered 
       (blank userref is a valid key and may already exist) */     
      
     field UserRef          as character serialize-name "userId"  init ?
     field SchemaName      as character serialize-name "schemaName"
     field Name            as character serialize-name "name"
     field Hidden          as logical   serialize-name "hidden"
   
     field CanRead         as logical serialize-name "canRead"
     field CanWrite        as logical serialize-name "canWrite"
     field CanCreate       as logical serialize-name "canCreate"
     field CanDelete       as logical serialize-name "canDelete"
     field CanDump         as logical serialize-name "canDump"
     field CanLoad         as logical serialize-name "canLoad"
  
    {daschema/entity.i}  
    index idxUser as primary unique UserRef SchemaName Name
    index idxSchemaName  SchemaName Name.
    
    
