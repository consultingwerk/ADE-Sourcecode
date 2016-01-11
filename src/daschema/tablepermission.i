/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : tablepermisssions.i
    Author(s)   : hdaniels
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define temp-table ttTablePermission no-undo serialize-name "tablePermissions"  {1} before-table ttTablePermissionCopy
     field SchemaName      as character serialize-name "schemaName"
     field Name            as character serialize-name "name"
     field Hidden          as logical   serialize-name "hidden"
     field Frozen          as logical   serialize-name "frozen"
     field CanRead         as character serialize-name "canRead"
     field CanWrite        as character serialize-name "canWrite"
     field CanCreate       as character serialize-name "canCreate"
     field CanDelete       as character serialize-name "canDelete"
     field CanDump         as character serialize-name "canDump"
     field CanLoad         as character serialize-name "canLoad"
     field trowid          as rowid     serialize-hidden
  
    {daschema/entity.i}  
    index idxRowid as unique trowid
    index idxSchemaName as primary unique Name.
    
    
