/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : userfieldpermisssions.i
    Author(s)   : hdaniels
    Created     :  
    Notes       : The table does not have SchemaName, which means the 
                  assumption that this is only PUB tables   
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttUserFieldPermission no-undo serialize-name "userFieldPermissions"  {1} 
         /*before-table ttUserFieldPermissionCopy*/
          
     /* init ? is needed to avoid already exists error during fill when 
        the OTHER fields in the unique index are mapped and also exists in 
        an index so the index update is trieggered 
        (blank userref is a valid key and may already exist) */     
     field UserRef         as character serialize-name "userId" init ?   
     field SchemaName      as character serialize-hidden /*serialize-name "schemaName"*/
     field TableName       as character serialize-name "tableName"
     /* name is unique when child of userid table... as used in collection and JSON */
     field Name            as character serialize-name "name" 
     field CanRead         as logical   serialize-name "canRead"
     field CanWrite        as logical   serialize-name "canWrite"
     field trowid          as rowid     serialize-hidden
     {daschema/entity.i}  
    index idxuser  as primary unique UserRef TableName Name 
    index idxtable    TableName Name.
    
    
