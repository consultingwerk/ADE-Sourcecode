/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : fieldpermisssions.i
    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttFieldPermission no-undo serialize-name "fieldPermissions"  {1} before-table ttFieldPermissionCopy
     field SchemaName      as character serialize-hidden /*serialize-name "schemaName"*/
     field TableName       as character serialize-name "tableName"
     field Name            as character serialize-name "name"
     field CanRead         as character serialize-name "canRead"
     field CanWrite        as character serialize-name "canWrite"
     field trowid          as rowid     serialize-hidden
     {daschema/entity.i}  
    index idxRowid as unique trowid
    index idxSchemaName as primary unique  TableName Name.
    
    
